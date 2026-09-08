from pathlib import Path
import unittest

from tools.bjts_sql_migration.converter import (
    convert_fragment,
    convert_source,
)
from tools.bjts_sql_migration.verifier import load_manifest


REPO_ROOT = Path(__file__).resolve().parents[3]


class FragmentConversionTests(unittest.TestCase):
    def test_integral_number_precision_boundary_preserves_exact_values(self):
        converted = convert_fragment(
            "v_small NUMBER(18); v_large NUMBER(20); v_ratio NUMBER(18,6);"
        )

        self.assertEqual(
            "v_small BIGINT; v_large DECIMAL(20,0); v_ratio DECIMAL(18,6);",
            converted,
        )

    def test_unconstrained_number_uses_an_exact_decimal(self):
        self.assertEqual("v_value DECIMAL(38,10);", convert_fragment("v_value NUMBER;"))

    def test_varchar2_without_length_gets_a_mysql_length(self):
        self.assertEqual(
            "p_code VARCHAR(4000); p_name VARCHAR(80);",
            convert_fragment("p_code VARCHAR2; p_name VARCHAR2(80);"),
        )

    def test_schema_names_inside_comments_and_literals_are_preserved(self):
        converted = convert_fragment(
            "SELECT * FROM TL_ADMIN.T1; -- TL_ADMIN.T2\n"
            "v_sql := 'SELECT * FROM TL_ADMIN.T3';"
        )

        self.assertIn("FROM T1", converted)
        self.assertIn("-- TL_ADMIN.T2", converted)
        self.assertIn("'SELECT * FROM TL_ADMIN.T3'", converted)

    def test_sequence_and_row_count_are_rewritten(self):
        converted = convert_fragment(
            "v_id := TL_TSSH.SEQ_YJ_DATA_YJXX.NEXTVAL; v_rows := SQL%ROWCOUNT;"
        )

        self.assertEqual(
            "SET v_id = SEQ_NEXTVAL('SEQ_YJ_DATA_YJXX'); SET v_rows = ROW_COUNT();",
            converted,
        )

    def test_common_oracle_functions_use_mysql_equivalents(self):
        converted = convert_fragment(
            "SELECT NVL(a, 'x'), NVL2(b, 1, 0), "
            "DECODE(c, 'A', 1, 'B', 2, 9), SYSDATE, "
            "ADD_MONTHS(d, 2) FROM DUAL;"
        )

        self.assertEqual(
            "SELECT IFNULL(a, 'x'), "
            "(CASE WHEN b IS NOT NULL THEN 1 ELSE 0 END), "
            "(CASE c WHEN 'A' THEN 1 WHEN 'B' THEN 2 ELSE 9 END), "
            "CURRENT_TIMESTAMP, DATE_ADD(d, INTERVAL 2 MONTH);",
            converted,
        )

    def test_date_format_literals_are_translated(self):
        converted = convert_fragment(
            "SELECT TO_CHAR(d, 'YYYYMMDD HH24:MI:SS'), "
            "TO_DATE(s, 'YYYY-MM-DD') FROM DUAL;"
        )

        self.assertEqual(
            "SELECT DATE_FORMAT(d, '%Y%m%d %H:%i:%s'), "
            "STR_TO_DATE(s, '%Y-%m-%d');",
            converted,
        )

    def test_oracle_constructs_in_comments_are_not_converted(self):
        source = "-- v_id NUMBER(20) := SEQ_A.NEXTVAL\n/* TL_BJTS.T1 VARCHAR2 */"

        self.assertEqual(source, convert_fragment(source))


class SourceConversionTests(unittest.TestCase):
    def test_every_manifest_source_returns_nonempty_sql_text(self):
        manifest = load_manifest(REPO_ROOT)

        for source_name, filenames in manifest.items():
            for filename in filenames:
                source_path = REPO_ROOT / "bjts" / source_name / filename
                with self.subTest(source=f"{source_name}/{filename}"):
                    result = convert_source(
                        f"{source_name}/{filename}",
                        source_path.read_bytes(),
                    )
                    self.assertIsInstance(result.sql, str)
                    self.assertTrue(result.sql.strip())

    def test_procedure_gets_mysql_client_wrapper(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_TEST(P_ID IN NUMBER(20)) AS
BEGIN
  NULL;
END;
/
"""

        result = convert_source("tl_admin/P_TEST.sql", source)

        self.assertEqual("PROCEDURE", result.source_object_type)
        self.assertEqual("PROCEDURE", result.target_object_type)
        self.assertEqual("P_TEST", result.object_name)
        self.assertTrue(result.sql.startswith("DELIMITER $$\n\nDROP PROCEDURE IF EXISTS P_TEST$$"))
        self.assertIn("CREATE PROCEDURE P_TEST", result.sql)
        self.assertTrue(result.sql.endswith("END$$\n\nDELIMITER ;\n"))
        self.assertNotIn("CREATE OR REPLACE", result.sql.upper())
        self.assertIn("DECIMAL(20,0)", result.sql)

    def test_parameters_and_declarations_use_mysql_order(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_TYPES(
  P_ID IN NUMBER(20),
  P_TEXT OUT VARCHAR2
) AS
  V_COUNT NUMBER(10) := 0;
  V_RUN_DATE DATE;
BEGIN
  V_COUNT := V_COUNT + 1;
  RETURN;
END P_TYPES;
/
"""

        result = convert_source("tl_admin/P_TYPES.sql", source)

        self.assertIn("IN P_ID DECIMAL(20,0)", result.sql)
        self.assertIn("OUT P_TEXT VARCHAR(4000)", result.sql)
        self.assertIn("DECLARE V_COUNT BIGINT DEFAULT 0;", result.sql)
        self.assertIn("DECLARE V_RUN_DATE DATETIME;", result.sql)
        self.assertIn("SET V_COUNT = V_COUNT + 1;", result.sql)
        self.assertIn("LEAVE routine_body;", result.sql)
        self.assertNotIn("\nAS\n", result.sql.upper())

    def test_date_parameter_uses_datetime(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_DATE(P_RUN_DATE IN DATE) AS
BEGIN
  NULL;
END P_DATE;
/
"""

        result = convert_source("tl_admin/P_DATE.sql", source)

        self.assertIn("IN P_RUN_DATE DATETIME", result.sql)

    def test_null_assignment_is_not_rewritten_as_a_noop_statement(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_NULL AS
  V_VALUE NUMBER;
BEGIN
  V_VALUE := NULL;
  NULL;
END P_NULL;
/
"""

        result = convert_source("tl_admin/P_NULL.sql", source)

        self.assertIn("SET V_VALUE = NULL;", result.sql)
        self.assertIn("DO 0;", result.sql)
        self.assertNotIn("= DO 0", result.sql)

    def test_scalar_function_has_mysql_characteristics_and_no_in_mode(self):
        source = b"""CREATE OR REPLACE FUNCTION F_DOUBLE(P_VALUE IN NUMBER)
RETURN NUMBER
IS
  V_RESULT NUMBER;
BEGIN
  V_RESULT := P_VALUE * 2;
  RETURN V_RESULT;
END F_DOUBLE;
/
"""

        result = convert_source("tl_bjts/F_DOUBLE.sql", source)

        self.assertIn("CREATE FUNCTION F_DOUBLE(P_VALUE DECIMAL(38,10))", result.sql)
        self.assertIn("RETURNS DECIMAL(38,10)", result.sql)
        self.assertIn("NOT DETERMINISTIC\nREADS SQL DATA", result.sql)
        self.assertIn("DECLARE V_RESULT DECIMAL(38,10);", result.sql)

    def test_gb18030_source_is_emitted_as_utf8_text(self):
        source = """CREATE OR REPLACE PROCEDURE P_CN AS
BEGIN
  -- 退税指标
  NULL;
END;
/
""".encode("gb18030")

        result = convert_source("tl_admin/P_CN.sql", source)

        self.assertIn("退税指标", result.sql)
        result.sql.encode("utf-8")

    def test_collection_function_is_classified_as_a_procedure(self):
        source = b"""CREATE OR REPLACE FUNCTION FUNC_ROWS(P_ID IN NUMBER)
RETURN TYPE_TB_ROWS
IS
BEGIN
  RETURN NULL;
END FUNC_ROWS;
/
"""

        result = convert_source("tl_bjts/FUNC_ROWS.sql", source)

        self.assertEqual("FUNCTION", result.source_object_type)
        self.assertEqual("PROCEDURE", result.target_object_type)
        self.assertEqual("FUNC_ROWS", result.object_name)
        self.assertIn("DROP PROCEDURE IF EXISTS FUNC_ROWS$$", result.sql)


if __name__ == "__main__":
    unittest.main()
