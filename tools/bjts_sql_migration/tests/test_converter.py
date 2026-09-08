from pathlib import Path
import re
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
            "TO_DATE(s, 'YYYY-MM-DD'), "
            "TO_DATE(cn, 'YYYY\"年\"MM\"月\"DD\"日\"') FROM DUAL;"
        )

        self.assertEqual(
            "SELECT DATE_FORMAT(d, '%Y%m%d %H:%i:%s'), "
            "STR_TO_DATE(s, '%Y-%m-%d'), "
            "STR_TO_DATE(cn, '%Y年%m月%d日');",
            converted,
        )

    def test_oracle_date_literals_and_date_truncation_use_mysql_date_expressions(self):
        converted = convert_fragment(
            "SELECT DATE'2024-01-02', TRUNC(SYSDATE), "
            "TRUNC(run_date, 'YY'), TRUNC(run_date, 'Q'), TRUNC(12.9);"
        )

        self.assertIn("CAST('2024-01-02' AS DATE)", converted)
        self.assertIn("DATE(CURRENT_TIMESTAMP)", converted)
        self.assertIn("MAKEDATE(YEAR(run_date), 1)", converted)
        self.assertIn("QUARTER(run_date)", converted)
        self.assertIn("TRUNCATE(12.9, 0)", converted)

    def test_oracle_fractional_day_offsets_and_date_differences_use_helpers(self):
        source = b"""CREATE OR REPLACE FUNCTION F_DATE_MATH(
  P_START IN DATE,
  P_END IN DATE
) RETURN NUMBER AS
  V_DAYS NUMBER;
BEGIN
  P_START := TRUNC(P_START) + 0.5;
  P_END := ADD_MONTHS(P_END, 1) - 1;
  V_DAYS := P_END - P_START;
  IF SYSDATE - P_START > 30 THEN
    V_DAYS := V_DAYS + 1;
  END IF;
  RETURN V_DAYS;
END F_DATE_MATH;
/
"""

        sql = convert_source("tl_admin/F_DATE_MATH.sql", source).sql

        self.assertIn("ORA_DATE_ADD(DATE(P_START), 0.5)", sql)
        self.assertIn("ORA_DATE_ADD(DATE_ADD(P_END, INTERVAL 1 MONTH), -(1))", sql)
        self.assertIn("ORA_DATE_DIFF(P_END, P_START)", sql)
        self.assertIn("ORA_DATE_DIFF(CURRENT_TIMESTAMP, P_START) > 30", sql)

    def test_guid_and_wm_concat_use_mysql_equivalents(self):
        converted = convert_fragment(
            "SELECT SYS_GUID(), WM_CONCAT(T.CODE) FROM T_DATA T;"
        )

        self.assertIn("REPLACE(UUID(), '-', '')", converted)
        self.assertIn("GROUP_CONCAT(T.CODE SEPARATOR ',')", converted)
        self.assertNotRegex(converted, r"(?i)\bSYS_GUID|\bWM_CONCAT")

    def test_next_day_uses_the_shared_strictly_later_weekday_helper(self):
        converted = convert_fragment("SELECT NEXT_DAY(run_date, 'SATURDAY');")

        self.assertEqual("SELECT ORA_NEXT_DAY(run_date, 'SATURDAY');", converted)

    def test_oracle_regexp_substr_capture_group_uses_compatibility_helper(self):
        converted = convert_fragment(
            "SELECT REGEXP_SUBSTR(value, pattern, 1, 1, 'i', 3), "
            "REGEXP_SUBSTR(value, pattern, 1, 1, 'i');"
        )

        self.assertEqual(
            "SELECT ORA_REGEXP_SUBSTR(value, pattern, 1, 1, 'i', 3), "
            "REGEXP_SUBSTR(value, pattern, 1, 1, 'i');",
            converted,
        )

    def test_concatenation_keeps_window_clause_bound_to_analytic_function(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_WINDOW_CONCAT AS
BEGIN
  INSERT INTO T_TARGET(V1, V2)
  SELECT '00' || ROW_NUMBER() OVER (ORDER BY CREATED_AT),
         ROW_NUMBER() OVER (ORDER BY CREATED_AT) || '00'
    FROM T_SOURCE;
END P_WINDOW_CONCAT;
/
"""

        converted = convert_source("tl_admin/P_WINDOW_CONCAT.sql", source).sql

        self.assertIn(
            "ORA_CONCAT('00', ROW_NUMBER() OVER (ORDER BY CREATED_AT))",
            converted,
        )
        self.assertIn(
            "ORA_CONCAT(ROW_NUMBER() OVER (ORDER BY CREATED_AT), '00')",
            converted,
        )

    def test_median_uses_json_aggregate_compatibility_helper(self):
        converted = convert_fragment(
            "SELECT GROUP_CODE, MEDIAN(AMOUNT) FROM T_DATA GROUP BY GROUP_CODE;"
        )

        self.assertEqual(
            "SELECT GROUP_CODE, ORA_MEDIAN(JSON_ARRAYAGG(AMOUNT)) "
            "FROM T_DATA GROUP BY GROUP_CODE;",
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

    def test_generated_sql_strips_trailing_whitespace(self):
        source = (
            b"CREATE OR REPLACE PROCEDURE P_CLEAN AS   \n"
            b"BEGIN  \n"
            b"  NULL;   \n"
            b"END; \n"
            b"/\n"
        )

        result = convert_source("tl_admin/P_CLEAN.sql", source)

        self.assertNotRegex(result.sql, r"(?m)[ \t]+$")

    def test_no_argument_routine_gets_required_empty_parameter_list(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_NO_ARGS AS
BEGIN
  NULL;
END P_NO_ARGS;
/
"""

        result = convert_source("tl_admin/P_NO_ARGS.sql", source)

        self.assertIn("CREATE PROCEDURE P_NO_ARGS()", result.sql)

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


class AdminRoutineTests(unittest.TestCase):
    def test_xj_swjg_collection_function_becomes_a_direct_result_set_procedure(self):
        source_path = REPO_ROOT / "bjts" / "tl_admin" / "FUNC_GET_XJ_SWJG.sql"

        sql = convert_source(
            "tl_admin/FUNC_GET_XJ_SWJG.sql",
            source_path.read_bytes(),
        ).sql

        self.assertIn("CREATE PROCEDURE func_get_xj_swjg", sql)
        self.assertIn("SELECT VIR_SWJGDM AS SWJG_DM", sql)
        self.assertIn("SELECT SWJG_DM AS SWJG_DM", sql)
        self.assertNotRegex(sql, r"(?i)TYPE_(?:TB|REC|CURSOR)")
        self.assertNotRegex(sql, r"(?i)\bOPEN\s+my_cursor\s+FOR\b")
        self.assertNotRegex(sql, r"(?i)%\s*NOTFOUND")

    def test_xj_swjg_table_function_call_is_inlined_without_a_temporary_table(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_XJ(P_CODE IN VARCHAR2) AS
BEGIN
  DELETE FROM T_TARGET
   WHERE SWJG_DM IN (
     SELECT SWJG_DM FROM TABLE(TL_ADMIN.FUNC_GET_XJ_SWJG(P_CODE))
   );
END P_XJ;
/
"""

        sql = convert_source("tl_admin/P_XJ.sql", source).sql

        self.assertNotRegex(sql, r"(?i)\bTABLE\s*\(\s*FUNC_GET_XJ_SWJG")
        self.assertNotRegex(sql, r"(?i)\bCALL\s+FUNC_GET_XJ_SWJG")
        self.assertNotRegex(sql, r"(?i)\bTEMPORARY\s+TABLE\b")
        self.assertIn("FROM DM_SWJG_VIRTUAL", sql)
        self.assertIn("FROM DM_SWJG", sql)
        self.assertIn("SUBSTR(P_CODE, 1, 1) = '2'", sql)
        self.assertIn("UNION ALL", sql)

    def test_exception_block_becomes_a_scoped_mysql_handler(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_HANDLER(P_ERROR OUT NUMBER) AS
  V_MESSAGE VARCHAR2(200);
  CURSOR C_ONE IS SELECT 1;
BEGIN
  SELECT 1;
EXCEPTION
  WHEN OTHERS THEN
    P_ERROR := SQLCODE;
    V_MESSAGE := SQLERRM;
END P_HANDLER;
/
"""

        sql = convert_source("tl_admin/P_HANDLER.sql", source).sql

        self.assertNotRegex(sql, r"(?i)\bEXCEPTION\b")
        self.assertNotIn("SQLCODE", sql.upper().replace("BJTS_SQLCODE", ""))
        self.assertNotIn("SQLERRM", sql.upper().replace("BJTS_SQLERRM", ""))
        self.assertIn("DECLARE EXIT HANDLER FOR SQLEXCEPTION", sql)
        self.assertIn("GET DIAGNOSTICS CONDITION 1", sql)
        self.assertIn("P_ERROR = BJTS_SQLCODE_001", sql)
        self.assertIn("V_MESSAGE = BJTS_SQLERRM_001", sql)
        self.assertLess(sql.index("DECLARE V_MESSAGE"), sql.index("DECLARE C_ONE CURSOR"))
        self.assertLess(
            sql.index("DECLARE C_ONE CURSOR"),
            sql.index("DECLARE EXIT HANDLER"),
        )

    def test_nested_exception_blocks_are_converted_from_the_inside_out(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_NESTED_HANDLER AS
BEGIN
  SELECT 1;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      SELECT 2;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        INSERT INTO T_LOG(MSG) VALUES ('inner missing');
      WHEN OTHERS THEN
        INSERT INTO T_LOG(MSG) VALUES ('inner error');
    END;
  WHEN OTHERS THEN
    INSERT INTO T_LOG(MSG) VALUES ('outer error');
END P_NESTED_HANDLER;
/
"""

        sql = convert_source("tl_admin/P_NESTED_HANDLER.sql", source).sql

        self.assertNotRegex(sql, r"(?i)\bEXCEPTION\b|\bWHEN\s+(?:NO_DATA_FOUND|OTHERS)")
        self.assertEqual(2, len(re.findall(r"(?i)HANDLER\s+FOR\s+NOT\s+FOUND", sql)))
        self.assertEqual(2, len(re.findall(r"(?i)HANDLER\s+FOR\s+SQLEXCEPTION", sql)))

    def test_implicit_cursor_for_loop_uses_fetch_and_a_local_not_found_handler(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_CURSOR AS
BEGIN
  FOR REC_ITEM IN (
    SELECT T.ITEM_ID, T.AMOUNT AS TOTAL_AMOUNT
      FROM T_ITEMS T
  ) LOOP
    INSERT INTO T_LOG(ITEM_ID, AMOUNT)
    VALUES (REC_ITEM.ITEM_ID, REC_ITEM.TOTAL_AMOUNT);
  END LOOP;
END P_CURSOR;
/
"""

        sql = convert_source("tl_admin/P_CURSOR.sql", source).sql

        self.assertNotRegex(sql, r"(?i)\bFOR\s+REC_ITEM\s+IN\b")
        self.assertNotRegex(sql, r"(?i)\bREC_ITEM\s*\.")
        self.assertIn("DECLARE BJTS_CURSOR_001 CURSOR FOR", sql)
        self.assertIn("DECLARE CONTINUE HANDLER FOR NOT FOUND", sql)
        self.assertIn(
            "FETCH BJTS_CURSOR_001 INTO "
            "BJTS_REC_ITEM_ITEM_ID_001, BJTS_REC_ITEM_TOTAL_AMOUNT_001",
            sql,
        )
        self.assertIn("OPEN BJTS_CURSOR_001", sql)
        self.assertIn("CLOSE BJTS_CURSOR_001", sql)

    def test_numeric_for_loop_evaluates_bounds_once_and_uses_while(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_NUMERIC(P_MAX IN NUMBER) AS
BEGIN
  FOR I IN 1 .. P_MAX LOOP
    INSERT INTO T_LOG(VALUE) VALUES (I);
  END LOOP;
END P_NUMERIC;
/
"""

        sql = convert_source("tl_admin/P_NUMERIC.sql", source).sql

        self.assertNotRegex(sql, r"(?i)\bFOR\s+I\s+IN\b")
        self.assertIn("DECLARE BJTS_FOR_I_001 DECIMAL(65,30) DEFAULT 1", sql)
        self.assertIn("DECLARE BJTS_FOR_END_001 DECIMAL(65,30) DEFAULT P_MAX", sql)
        self.assertIn("WHILE BJTS_FOR_I_001 <= BJTS_FOR_END_001 DO", sql)
        self.assertIn("VALUES (BJTS_FOR_I_001)", sql)
        self.assertIn("END WHILE", sql)

    def test_parameterized_named_cursor_is_redeclared_with_bound_arguments(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_NAMED_CURSOR(P_KIND IN VARCHAR2) AS
  CURSOR C_ITEMS(C_KIND IN VARCHAR2) IS
    SELECT T.ITEM_ID FROM T_ITEMS T WHERE T.KIND = C_KIND;
BEGIN
  FOR REC_ITEM IN C_ITEMS(P_KIND) LOOP
    INSERT INTO T_LOG(ITEM_ID) VALUES (REC_ITEM.ITEM_ID);
  END LOOP;
END P_NAMED_CURSOR;
/
"""

        sql = convert_source("tl_admin/P_NAMED_CURSOR.sql", source).sql

        self.assertNotRegex(sql, r"(?i)DECLARE\s+C_ITEMS\s*\(")
        self.assertNotRegex(sql, r"(?i)\bFOR\s+REC_ITEM\s+IN\s+C_ITEMS")
        self.assertIn("DECLARE BJTS_NAMED_CURSOR_001 CURSOR FOR", sql)
        self.assertIn("WHERE T.KIND = (P_KIND)", sql)
        self.assertIn("FETCH BJTS_NAMED_CURSOR_001 INTO", sql)

    def test_oracle_while_loop_uses_do_and_end_while(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_WHILE AS
  V_VALUE NUMBER := 0;
BEGIN
  WHILE V_VALUE < 3 LOOP
    V_VALUE := V_VALUE + 1;
  END LOOP;
END P_WHILE;
/
"""

        sql = convert_source("tl_admin/P_WHILE.sql", source).sql

        self.assertIn("WHILE V_VALUE < 3 DO", sql)
        self.assertIn("END WHILE", sql)
        self.assertNotRegex(sql, r"(?i)\bWHILE\b[^;]+\bLOOP\b")

    def test_open_fetch_loop_expands_rowtype_and_scopes_fetch_handler(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_FETCH(P_KIND IN VARCHAR2) AS
  CURSOR C_ITEMS(C_KIND IN VARCHAR2) IS
    SELECT T.ITEM_ID, T.ITEM_NAME FROM T_ITEMS T WHERE T.KIND = C_KIND;
  R_ITEM C_ITEMS%ROWTYPE;
BEGIN
  OPEN C_ITEMS(P_KIND);
  LOOP
    FETCH C_ITEMS INTO R_ITEM;
    EXIT WHEN C_ITEMS%NOTFOUND;
    INSERT INTO T_LOG(ITEM_ID, ITEM_NAME)
    VALUES (R_ITEM.ITEM_ID, R_ITEM.ITEM_NAME);
  END LOOP;
  CLOSE C_ITEMS;
END P_FETCH;
/
"""

        sql = convert_source("tl_admin/P_FETCH.sql", source).sql

        self.assertNotRegex(sql, r"(?i)%\s*(?:ROWTYPE|NOTFOUND)")
        self.assertNotRegex(sql, r"(?i)DECLARE\s+C_ITEMS\s*\(")
        self.assertIn("DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR", sql)
        self.assertIn("WHERE T.KIND = (P_KIND)", sql)
        self.assertIn("DECLARE CONTINUE HANDLER FOR NOT FOUND", sql)
        self.assertIn(
            "FETCH BJTS_FETCH_CURSOR_001 INTO "
            "BJTS_R_ITEM_ITEM_ID_001, BJTS_R_ITEM_ITEM_NAME_001",
            sql,
        )
        self.assertIn(
            "VALUES (BJTS_R_ITEM_ITEM_ID_001, BJTS_R_ITEM_ITEM_NAME_001)",
            sql,
        )

    def test_standalone_procedure_invocation_uses_call(self):
        source = b"""CREATE OR REPLACE PROCEDURE PRO_PARENT(P_ID IN NUMBER) AS
BEGIN
  PRO_CHILD(P_ID);
  PROC_AUDIT(P_ID, 'done');
END PRO_PARENT;
/
"""

        sql = convert_source("tl_admin/PRO_PARENT.sql", source).sql

        self.assertIn("CALL PRO_CHILD(P_ID);", sql)
        self.assertIn("CALL PROC_AUDIT(P_ID, 'done');", sql)

    def test_standalone_no_argument_procedure_invocation_uses_call(self):
        source = b"""CREATE OR REPLACE PROCEDURE PRO_PARENT AS
BEGIN
  PRO_CHILD;
END PRO_PARENT;
/
"""

        sql = convert_source("tl_admin/PRO_PARENT.sql", source).sql

        self.assertIn("CALL PRO_CHILD();", sql)

    def test_function_converted_to_procedure_call_appends_the_return_target(self):
        source = b"""CREATE OR REPLACE PROCEDURE PRO_PARENT(P_ID IN NUMBER) AS
  V_DETAIL VARCHAR2(100);
  V_RESULT NUMBER;
BEGIN
  V_RESULT := FUNC_XXBD_QUERY_CPCODEKZ(P_ID, 'TYPE', SYSDATE, V_DETAIL);
END PRO_PARENT;
/
"""

        sql = convert_source("tl_admin/PRO_PARENT.sql", source).sql

        self.assertIn(
            "CALL FUNC_XXBD_QUERY_CPCODEKZ(P_ID, 'TYPE', CURRENT_TIMESTAMP, "
            "V_DETAIL, V_RESULT);",
            sql,
        )
        self.assertNotRegex(sql, r"(?i)SET\s+V_RESULT\s*=\s*FUNC_XXBD_QUERY_CPCODEKZ")

    def test_concatenation_uses_null_preserving_compatibility_function(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_CONCAT(P_VALUE IN VARCHAR2) AS
  V_TEXT VARCHAR2(200);
BEGIN
  V_TEXT := 'prefix-' || P_VALUE || NVL('-suffix', '');
  INSERT INTO T_LOG(MSG) VALUES ('[' || V_TEXT || ']');
END P_CONCAT;
/
"""

        sql = convert_source("tl_admin/P_CONCAT.sql", source).sql

        self.assertNotIn("||", sql)
        self.assertIn(
            "ORA_CONCAT(ORA_CONCAT('prefix-', P_VALUE), IFNULL('-suffix', ''))",
            sql,
        )
        self.assertIn("ORA_CONCAT(ORA_CONCAT('[', V_TEXT), ']')", sql)

    def test_execute_immediate_uses_prepare_bind_variables_and_dynamic_output(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_DYNAMIC(
  P_ID IN NUMBER,
  P_VALUE IN VARCHAR2,
  P_COUNT OUT NUMBER
) AS
  V_SQL VARCHAR2(4000);
BEGIN
  V_SQL := 'UPDATE TL_ADMIN.T_DATA SET VALUE=:1 WHERE ID=:2';
  EXECUTE IMMEDIATE V_SQL USING P_VALUE, P_ID;
  EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM TL_ADMIN.T_DATA' INTO P_COUNT;
END P_DYNAMIC;
/
"""

        sql = convert_source("tl_admin/P_DYNAMIC.sql", source).sql

        self.assertNotRegex(sql, r"(?i)\bEXECUTE\s+IMMEDIATE\b")
        self.assertIn("'UPDATE T_DATA SET VALUE=? WHERE ID=?'", sql)
        self.assertIn("SET @BJTS_BIND_001_001 = P_VALUE", sql)
        self.assertIn("SET @BJTS_BIND_001_002 = P_ID", sql)
        self.assertIn(
            "EXECUTE BJTS_DYNAMIC_STMT_001 USING "
            "@BJTS_BIND_001_001, @BJTS_BIND_001_002",
            sql,
        )
        self.assertIn("PREPARE BJTS_DYNAMIC_STMT_002", sql)
        self.assertIn("INTO @BJTS_DYNAMIC_OUT_002_001", sql)
        self.assertIn("SET P_COUNT = @BJTS_DYNAMIC_OUT_002_001", sql)
        self.assertIn("DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_002", sql)

    def test_rownum_preserves_existence_scalar_and_numbering_semantics(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_ROWNUM(P_COUNT OUT NUMBER) AS
BEGIN
  SELECT COUNT(1) INTO P_COUNT FROM T_DATA WHERE ACTIVE = 'Y' AND ROWNUM = 1;
  UPDATE T_TARGET T
     SET T.VALUE = (SELECT S.VALUE FROM T_SOURCE S
                     WHERE S.ID = T.ID AND ROWNUM = 1);
  INSERT INTO T_NUMBERED(ID, RN)
  SELECT T.ID, ROWNUM FROM T_DATA T;
  UPDATE T_BATCH SET FLAG = 'Y' WHERE FLAG = 'N' AND ROWNUM < 1001;
END P_ROWNUM;
/
"""

        sql = convert_source("tl_admin/P_ROWNUM.sql", source).sql

        self.assertNotRegex(sql, r"(?i)\bROWNUM\b")
        self.assertIn("LEAST(COUNT(1), 1)", sql)
        self.assertRegex(
            sql,
            r"(?is)SELECT S\.VALUE FROM T_SOURCE S.+?1=1\s+LIMIT 1\)",
        )
        self.assertIn("SELECT T.ID, ROW_NUMBER() OVER () FROM T_DATA T", sql)
        self.assertRegex(sql, r"(?is)UPDATE T_BATCH.+?1=1\s+LIMIT 1000;")

    def test_dbms_output_is_reduced_to_a_mysql_no_result_expression(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_LOG(P_VALUE IN VARCHAR2) AS
BEGIN
  SYS.DBMS_OUTPUT.PUT_LINE('value=' || P_VALUE);
END P_LOG;
/
"""

        sql = convert_source("tl_admin/P_LOG.sql", source).sql

        self.assertNotRegex(sql, r"(?i)\bDBMS_OUTPUT\b")
        self.assertIn("DO ORA_CONCAT('value=', P_VALUE);", sql)

    def test_raise_application_error_delegates_to_the_shared_signal_procedure(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_RAISE(P_ID IN NUMBER) AS
BEGIN
  RAISE_APPLICATION_ERROR(-20001, 'bad id ' || P_ID);
END P_RAISE;
/
"""

        sql = convert_source("tl_admin/P_RAISE.sql", source).sql

        self.assertIn(
            "CALL ORA_RAISE_APPLICATION_ERROR(-20001, ORA_CONCAT('bad id ', P_ID));",
            sql,
        )
        self.assertNotRegex(sql, r"(?i)\bRAISE_APPLICATION_ERROR\s*\(")

    def test_merge_uses_update_join_and_guarded_insert_without_unique_key_assumption(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_MERGE AS
BEGIN
  MERGE INTO T_TARGET A
  USING (SELECT S.ID, S.VALUE FROM T_SOURCE S) B
     ON (A.ID = B.ID)
  WHEN MATCHED THEN
    UPDATE SET A.VALUE = B.VALUE, A.UPDATE_TIME = SYSDATE
  WHEN NOT MATCHED THEN
    INSERT (ID, VALUE, UPDATE_TIME)
    VALUES (B.ID, B.VALUE, SYSDATE);
END P_MERGE;
/
"""

        sql = convert_source("tl_admin/P_MERGE.sql", source).sql

        self.assertNotRegex(sql, r"(?i)\bMERGE\s+INTO\b")
        self.assertRegex(sql, r"(?is)UPDATE T_TARGET AS A\s+JOIN\s*\(\s*SELECT")
        self.assertIn("SET VALUE = B.VALUE, UPDATE_TIME = CURRENT_TIMESTAMP", sql)
        self.assertRegex(sql, r"(?is)INSERT INTO T_TARGET\s*\(ID, VALUE, UPDATE_TIME\)")
        self.assertRegex(
            sql,
            r"(?is)WHERE NOT EXISTS\s*\(\s*SELECT 1 FROM T_TARGET AS A "
            r"WHERE A.ID = B.ID\s*\)",
        )

    def test_update_and_delete_target_aliases_use_mysql_assignment_syntax(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_DML_ALIAS AS
BEGIN
  UPDATE T_TARGET T
     SET T.VALUE = T.VALUE + 1,
         T.UPDATED_AT = SYSDATE
   WHERE T.ID = 7;
  DELETE FROM T_LOG L WHERE L.ID = 7;
END P_DML_ALIAS;
/
"""

        sql = convert_source("tl_admin/P_DML_ALIAS.sql", source).sql

        self.assertRegex(sql, r"(?is)UPDATE\s+T_TARGET\s+AS\s+T\s+SET\s+VALUE\s*=")
        self.assertIn("VALUE = T.VALUE + 1", sql)
        self.assertIn("UPDATED_AT = CURRENT_TIMESTAMP", sql)
        self.assertRegex(sql, r"(?is)UPDATED_AT\s*=\s*CURRENT_TIMESTAMP\s+WHERE")
        self.assertRegex(sql, r"(?is)DELETE\s+FROM\s+T_LOG\s+AS\s+L\s+WHERE")
        self.assertNotRegex(sql, r"(?i)\bSET\s+T\s*\.\s*(?:VALUE|UPDATED_AT)\s*=")

    def test_oracle_tuple_update_becomes_scalar_mysql_assignments(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_TUPLE_UPDATE AS
BEGIN
  UPDATE T_TARGET T
     SET (T.VALUE, T.UPDATED_AT) = (
       SELECT S.VALUE, S.UPDATED_AT
         FROM T_SOURCE S
        WHERE S.ID = T.ID
     )
   WHERE T.ACTIVE = 'Y';
END P_TUPLE_UPDATE;
/
"""

        sql = convert_source("tl_admin/P_TUPLE_UPDATE.sql", source).sql

        self.assertNotRegex(sql, r"(?is)\bSET\s*\(")
        self.assertRegex(
            sql,
            r"(?is)SET\s+VALUE\s*=\s*\(\s*SELECT\s+S\.VALUE\s+FROM\s+T_SOURCE",
        )
        self.assertRegex(
            sql,
            r"(?is)UPDATED_AT\s*=\s*\(\s*SELECT\s+S\.UPDATED_AT\s+FROM\s+T_SOURCE",
        )
        self.assertEqual(2, len(re.findall(r"(?i)WHERE\s+S\.ID\s*=\s*T\.ID", sql)))

    def test_plain_loop_exit_conditions_and_bare_exit_use_a_mysql_label(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_PLAIN_LOOP AS
  V_VALUE NUMBER := 0;
BEGIN
  LOOP
    EXIT WHEN V_VALUE > 3;
    SET V_VALUE = V_VALUE + 1;
    IF V_VALUE = 2 THEN
      EXIT;
    END IF;
  END LOOP;
END P_PLAIN_LOOP;
/
"""

        sql = convert_source("tl_admin/P_PLAIN_LOOP.sql", source).sql

        self.assertRegex(sql, r"(?i)BJTS_LOOP_\d{3}:\s+LOOP")
        self.assertRegex(sql, r"(?i)IF\s+V_VALUE\s*>\s*3\s+THEN\s+LEAVE\s+BJTS_LOOP_\d{3}")
        self.assertRegex(sql, r"(?i)LEAVE\s+BJTS_LOOP_\d{3};")
        self.assertRegex(sql, r"(?i)END\s+LOOP\s+BJTS_LOOP_\d{3};")
        self.assertNotRegex(sql, r"(?i)\bEXIT(?:\s+WHEN)?\b|\bEND\s+LOOP\s*;")


class BjtsRoutineTests(unittest.TestCase):
    def convert_checked_in(self, filename: str) -> str:
        source_path = REPO_ROOT / "bjts" / "tl_bjts" / filename
        return convert_source(f"tl_bjts/{filename}", source_path.read_bytes()).sql

    def test_dynamic_collection_function_executes_a_shaped_result_query(self):
        sql = self.convert_checked_in("FUNC_GET_SBHZXX.sql")

        self.assertIn("CREATE PROCEDURE func_get_sbhzxx", sql)
        self.assertIn("PREPARE BJTS_RESULT_STMT_001", sql)
        self.assertIn("EXECUTE BJTS_RESULT_STMT_001", sql)
        self.assertIn("as ywzldm", sql.lower())
        self.assertIn("as cqcnt", sql.lower())
        self.assertNotRegex(sql, r"(?i)TYPE_(?:TB|REC|CURSOR)")
        self.assertNotRegex(sql, r"(?i)\bOPEN\s+my_cursor\s+FOR\b")
        self.assertNotRegex(sql, r"(?i)%\s*NOTFOUND|\.\s*EXTEND\b")
        self.assertNotIn("||", sql)

    def test_static_collection_function_projects_object_fields_as_result_columns(self):
        sql = self.convert_checked_in("FUNC_GET_SBLIST.sql")

        for column in (
            "sbid",
            "sssq",
            "sbrq",
            "qyhgdm",
            "nsrmc",
            "sbywbdm",
            "flglcd",
            "zzsbb",
            "zs_swjg_mc",
            "ts_swjg_mc",
            "tsjsfs",
            "sbywbmc",
            "sbtmse",
            "ydcnt",
            "yjcnt",
            "cqbz",
        ):
            self.assertRegex(sql, rf"(?i)\bAS\s+{column}\b")
        self.assertNotRegex(sql, r"(?i)TYPE_(?:TB|REC)_SBLIST")
        self.assertNotRegex(sql, r"(?i)\bFOR\s+v_rec\s+IN\b|\.\s*EXTEND\b")
        self.assertIn("LPAD(CAST(BJTS_RESULT_SOURCE.sbpc AS CHAR), 2, '0')", sql)

    def test_single_object_collection_function_returns_one_shaped_row(self):
        sql = self.convert_checked_in("FUNC_SHZS_RWWP.sql")

        self.assertRegex(
            sql,
            r"(?is)SELECT\s+v_WTDXSFDM\s+AS\s+wpdxsfdm.+?"
            r"v_ErrMsg\s+AS\s+ERRMSG",
        )
        self.assertNotRegex(sql, r"(?i)TYPE_(?:TB|REC)_SHZS_RWWP")
        self.assertNotRegex(sql, r"(?i)\.\s*EXTEND\b")

    def test_pipelined_split_function_becomes_a_recursive_result_set_procedure(self):
        sql = self.convert_checked_in("FUNC_STRSPLIT.sql")

        self.assertIn("CREATE PROCEDURE FunC_StrSplit", sql)
        self.assertIn("WITH RECURSIVE BJTS_SPLIT", sql)
        self.assertRegex(sql, r"(?i)SELECT\s+TOKEN\s+AS\s+COLUMN_VALUE")
        self.assertNotRegex(sql, r"(?i)\bPIPELINED\b|\bPIPE\s+ROW\b")
        self.assertNotRegex(sql, r"(?i)STRSPLIT_TYPE")

    def test_internal_split_consumer_uses_json_table_instead_of_result_procedure(self):
        sql = self.convert_checked_in("FUNC_GET_JDFWMS.sql")

        self.assertIn("JSON_TABLE(ORA_SPLIT_JSON", sql)
        self.assertNotRegex(sql, r"(?i)\bTABLE\s*\(\s*FUNC_STRSPLIT")
        self.assertNotRegex(sql, r"(?i)\bCALL\s+FUNC_STRSPLIT")

    def test_autonomous_dynamic_loader_becomes_one_prepared_insert_procedure(self):
        sql = self.convert_checked_in("TEMP_DATA_INIT.sql")

        self.assertIn("CREATE PROCEDURE TEMP_DATA_INIT", sql)
        self.assertIn("OUT P_RESULT", sql)
        self.assertRegex(
            sql,
            r"(?is)INSERT\s+INTO\s+TB_REPORT_DATA.+?SELECT.+?FROM\s*\(",
        )
        self.assertIn("PREPARE BJTS_DYNAMIC_STMT_001", sql)
        self.assertIn("SET P_RESULT = (Result)", sql)
        self.assertNotRegex(sql, r"(?i)\bPRAGMA\b|TYPE_CURSOR|%\s*NOTFOUND")
        self.assertNotRegex(sql, r"(?i)\bOPEN\s+my_cursor\s+FOR\b")

    def test_multiple_oracle_exception_branches_become_specific_mysql_handlers(self):
        source = b"""CREATE OR REPLACE PROCEDURE P_MULTI_HANDLER AS
BEGIN
  SELECT VALUE INTO @VALUE FROM T_ONE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT INTO T_LOG(MSG) VALUES ('missing');
  WHEN TOO_MANY_ROWS THEN
    INSERT INTO T_LOG(MSG) VALUES ('many');
  WHEN OTHERS THEN
    INSERT INTO T_LOG(MSG) VALUES (SQLERRM);
END P_MULTI_HANDLER;
/
"""

        sql = convert_source("tl_bjts/P_MULTI_HANDLER.sql", source).sql

        self.assertIn("DECLARE EXIT HANDLER FOR NOT FOUND", sql)
        self.assertIn("DECLARE EXIT HANDLER FOR 1172", sql)
        self.assertIn("DECLARE EXIT HANDLER FOR SQLEXCEPTION", sql)
        self.assertIn("VALUES ('missing')", sql)
        self.assertIn("VALUES ('many')", sql)
        self.assertNotRegex(sql, r"(?i)\bWHEN\s+(?:NO_DATA_FOUND|TOO_MANY_ROWS|OTHERS)")

    def test_random_assignee_function_has_no_residual_oracle_handler_or_dynamic_sql(self):
        sql = self.convert_checked_in("FUNC_GET_RANDOM_SBR.sql")

        self.assertNotRegex(sql, r"(?i)\bWHEN\s+(?:NO_DATA_FOUND|OTHERS)")
        self.assertNotRegex(sql, r"(?i)\bROWNUM\b|\bNVL\s*\(")

    def test_exit_inside_while_uses_a_mysql_loop_label(self):
        sql = self.convert_checked_in("FUNC_GET_QXSWJG.sql")

        self.assertRegex(sql, r"(?i)BJTS_WHILE_\d{3}:\s+WHILE\s+i\s*>\s*1\s+DO")
        self.assertRegex(sql, r"(?i)LEAVE\s+BJTS_WHILE_\d{3}\s*;")
        self.assertRegex(sql, r"(?i)END\s+WHILE\s+BJTS_WHILE_\d{3}\s*;")
        self.assertNotRegex(sql, r"(?i)\bEXIT\s*;")

    def test_line_comments_use_mysql_required_whitespace_after_dashes(self):
        sql = self.convert_checked_in("FUNC_GET_QXSWJG.sql")

        self.assertNotRegex(sql, r"(?m)^[ \t]*--(?=\S)")
        self.assertIn("-- DBMS_OUTPUT.put_line", sql)

    def test_window_function_concatenation_preserves_over_binding(self):
        source_path = (
            REPO_ROOT / "bjts" / "tl_admin" / "PRO_TJBB_DT_B01106_CSH_NEW.sql"
        )
        sql = convert_source(
            "tl_admin/PRO_TJBB_DT_B01106_CSH_NEW.sql",
            source_path.read_bytes(),
        ).sql

        self.assertIn(
            "ORA_CONCAT('00', ROW_NUMBER() OVER (ORDER BY T.YSJC_DATE))",
            sql,
        )
        self.assertNotRegex(sql, r"(?i)ORA_CONCAT\([^\n]+ROW_NUMBER\(\)\)\s+OVER")


class TsshRoutineTests(unittest.TestCase):
    def convert_checked_in(self, filename: str) -> str:
        source_path = REPO_ROOT / "bjts" / "tl_tssh" / filename
        return convert_source(f"tl_tssh/{filename}", source_path.read_bytes()).sql

    def test_rowid_deduplication_uses_a_scoped_unique_temporary_copy(self):
        sql = self.convert_checked_in("PRO_DEAL_AFTER_ETL.sql")

        self.assertNotRegex(sql, r"(?i)\bROWID\b")
        self.assertIn(
            "CREATE TEMPORARY TABLE BJTS_TMP_CKTS_LC_SHXX_ZF LIKE CKTS_LC_SHXX_ZF",
            sql,
        )
        self.assertIn("ADD UNIQUE KEY BJTS_UK_UUID (UUID)", sql)
        self.assertRegex(
            sql,
            r"(?is)INSERT IGNORE INTO BJTS_TMP_CKTS_LC_SHXX_ZF\s+"
            r"SELECT \* FROM CKTS_LC_SHXX_ZF",
        )
        self.assertIn("DROP TEMPORARY TABLE BJTS_TMP_CKTS_LC_SHXX_ZF", sql)

    def test_calls_to_converted_scalar_functions_use_procedure_out_arguments(self):
        qspj_sql = self.convert_checked_in("PRO_JKGL_COMPUTE_ZBU_QSPJ.sql")
        plate_sql = self.convert_checked_in("PRO_FXGL_SZYJ_WLXX.sql")

        self.assertRegex(
            qspj_sql,
            r"(?i)CALL\s+F_MY_STDAVG_TMPTB\s*\(\s*V_SQL_SELECT\s*,\s*V_QSPJZ\s*\)",
        )
        self.assertNotRegex(qspj_sql, r"(?i)SET\s+V_QSPJZ\s*=\s*F_MY_STDAVG_TMPTB")
        self.assertRegex(
            plate_sql,
            r"(?i)CALL\s+F_WLGL_EXTRACT_PLATE\s*\([^;]+LN_ADDR\s*,\s*LC_CPH\s*\)",
        )
        self.assertNotRegex(plate_sql, r"(?i)SET\s+LC_CPH\s*=\s*F_WLGL_EXTRACT_PLATE")

    def test_sql_passed_to_converted_dynamic_function_is_converted_at_its_producer(self):
        sql = self.convert_checked_in("PRO_JKGL_COMPUTE_ZBU_QSPJ.sql")

        self.assertNotRegex(sql, r"(?i)TL_(?:ADMIN|BJTS|TSSH)\s*\.")
        self.assertNotRegex(sql, r"(?i)\bDATE''")
        self.assertIn("CALL F_MY_STDAVG_TMPTB(V_SQL_SELECT, V_QSPJZ)", sql)

    def test_plain_loop_with_parenthesized_exit_when_is_lowered(self):
        sql = self.convert_checked_in("F_MY_STDAVG_TMPTB.sql")

        self.assertRegex(
            sql,
            r"(?i)IF\s*\(\s*v_deeps\s*>\s*3\s*\)\s+THEN\s+"
            r"LEAVE\s+BJTS_LOOP_\d{3}",
        )
        self.assertNotRegex(sql, r"(?i)\bEXIT\s+WHEN\b")

    def test_oracle_global_temporary_table_dynamic_sql_is_mysql_compatible(self):
        sql = self.convert_checked_in("F_MY_STDAVG_TMPTB.sql")

        self.assertNotRegex(
            sql,
            r"(?i)\bGLOBAL\s+TEMPORARY\b|\bON\s+COMMIT\s+DELETE\s+ROWS\b|"
            r"\bUSER_TABLES\b",
        )
        self.assertIn("CREATE TEMPORARY TABLE TMP_STDDEV", sql)
        self.assertIn("DROP TEMPORARY TABLE IF EXISTS TMP_STDDEV", sql)

    def test_application_sql_payloads_are_converted_to_mysql_dialect(self):
        sql = self.convert_checked_in("PRO_JKGL_COMPUTE_W30101.sql")

        payload_line = next(
            line for line in sql.splitlines() if "[s]select" in line.lower()
        )
        self.assertNotRegex(payload_line, r"(?i)TL_(?:ADMIN|BJTS|TSSH)\s*\.")
        self.assertNotRegex(payload_line, r"(?i)\bTO_CHAR\s*\(|\bDATE''")
        self.assertIn("DATE_FORMAT(hg.ckrq_1, ''%Y-%m-%d'')", payload_line)

    def test_date_arithmetic_on_generated_cursor_fields_preserves_day_semantics(self):
        jd_sql = self.convert_checked_in("PRO_JKGL_COMPUTE_ZBU_JD.sql")
        temp_sql = self.convert_checked_in("TEMP_JKGL_COMPUTE_ZBU_JD.sql")

        self.assertIn(
            "ORA_DATE_ADD(BJTS_CUR_BGQ_BGQ_Z_001, 1)",
            jd_sql,
        )
        self.assertNotRegex(
            jd_sql,
            r"(?i)BJTS_CUR_BGQ_BGQ_[QZ]_\d{3}\s*[+-]\s*\d+",
        )
        self.assertIn("ORA_DATE_ADD(T.BGQ_Z, 1) AS BGQ_Z", temp_sql)

    def test_regex_backslashes_are_escaped_for_mysql_string_literals(self):
        sql = self.convert_checked_in("F_WLGL_EXTRACT_DATE.sql")

        self.assertIn(r"'^\\d{4}[-/\\.]", sql)
        self.assertNotRegex(sql, r"(?<!\\)\\[dDsSwW]")
        self.assertIn("STR_TO_DATE(v_date_str, '%Y年%m月%d日')", sql)

    def test_oracle_regexp_capture_group_calls_use_mysql_helper(self):
        from_sql = self.convert_checked_in("F_WLGL_EXTRACT_FROM.sql")
        parcel_sql = self.convert_checked_in("F_WLGL_EXTRACT_PARCEL.sql")

        self.assertIn("ORA_REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 3)", from_sql)
        self.assertIn("ORA_REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 2)", parcel_sql)
        self.assertNotRegex(
            from_sql + parcel_sql,
            r"(?i)\bREGEXP_SUBSTR\s*\([^;\n]+,\s*[1-9]\s*\)",
        )

    def test_oracle_median_aggregates_use_window_based_mysql_helper(self):
        profit_sql = self.convert_checked_in("PRO_FXGL_SZYJ_MMYLRL_PERM.sql")
        indicator_sql = self.convert_checked_in("PRO_JKGL_COMPUTE_W20201.sql")

        combined = profit_sql + indicator_sql
        self.assertEqual(5, combined.count("ORA_MEDIAN(JSON_ARRAYAGG("))
        self.assertNotRegex(combined, r"(?i)(?<!ORA_)\bMEDIAN\s*\(")


if __name__ == "__main__":
    unittest.main()
