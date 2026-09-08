from pathlib import Path
from tempfile import TemporaryDirectory
import unittest

from tools.bjts_sql_migration.verifier import (
    compare_manifest,
    load_manifest,
    scan_output_file,
    validate_output_structure,
)


REPO_ROOT = Path(__file__).resolve().parents[3]


class ManifestTests(unittest.TestCase):
    def test_locked_manifest_matches_the_source_tree(self):
        manifest = load_manifest(REPO_ROOT)

        self.assertEqual(96, len(manifest["tl_admin"]))
        self.assertEqual(114, len(manifest["tl_bjts"]))
        self.assertEqual(146, len(manifest["tl_tssh"]))
        for source_name, filenames in manifest.items():
            actual = sorted(
                path.name
                for path in (REPO_ROOT / "bjts" / source_name).glob("*.sql")
            )
            self.assertEqual(actual, filenames)

    def test_outputs_match_every_locked_source_filename(self):
        self.assertEqual([], compare_manifest(REPO_ROOT))


class ScannerTests(unittest.TestCase):
    def scan(self, sql: str):
        with TemporaryDirectory() as tmp_dir:
            path = Path(tmp_dir) / "routine.sql"
            path.write_text(sql, encoding="utf-8")
            return scan_output_file(path)

    def test_oracle_words_in_comments_and_literals_are_ignored(self):
        findings = self.scan(
            """-- TL_ADMIN.T1 VARCHAR2 SEQ_A.NEXTVAL
DELIMITER $$
DROP PROCEDURE IF EXISTS P_TEST$$
CREATE PROCEDURE P_TEST()
BEGIN
  SET @message = 'TL_BJTS.T2 VARCHAR2 SEQ_B.NEXTVAL';
END$$
DELIMITER ;
"""
        )

        self.assertEqual([], findings)

    def test_executable_oracle_constructs_are_reported_with_lines(self):
        findings = self.scan(
            """CREATE OR REPLACE PROCEDURE P_TEST AS
  v_id NUMBER(20);
BEGIN
  v_id := TL_TSSH.SEQ_A.NEXTVAL;
END;
/
"""
        )

        self.assertEqual(
            [
                ("oracle_create_or_replace", 1),
                ("oracle_number_type", 2),
                ("oracle_assignment", 4),
                ("oracle_schema_prefix", 4),
                ("oracle_sequence", 4),
                ("oracle_slash_terminator", 6),
            ],
            [(finding.code, finding.line) for finding in findings],
        )

    def test_additional_oracle_only_constructs_are_reported(self):
        findings = self.scan(
            """CREATE PROCEDURE P_TEST()
BEGIN
  PRAGMA AUTONOMOUS_TRANSACTION;
  SET @v = NEXT_DAY(CURRENT_TIMESTAMP, 'SATURDAY');
  SET @v = SYS_GUID();
  SELECT WM_CONCAT(CODE), TRUNC(CREATED_AT) FROM T_DATA;
  RAISE_APPLICATION_ERROR(-20001, 'bad');
  EXIT WHEN @done = 1;
  EXIT;
  CONTINUE;
  SET (A, B) = (SELECT X, Y FROM T_SOURCE);
  SET @v = T_DATA.ROWID;
  PIPE ROW(@v);
END
"""
        )

        self.assertEqual(
            {
                "oracle_exit_when",
                "oracle_exit",
                "oracle_continue",
                "oracle_next_day",
                "oracle_pragma",
                "oracle_raise_application_error",
                "oracle_rowid",
                "oracle_sys_guid",
                "oracle_trunc",
                "oracle_tuple_update",
                "oracle_wm_concat",
                "oracle_pipe_row",
            },
            {finding.code for finding in findings},
        )

    def test_extended_oracle_sql_and_plsql_constructs_are_reported(self):
        findings = self.scan(
            """CREATE PROCEDURE P_TEST()
BEGIN
  SET @v = TO_NUMBER(CODE);
  SET @v = CHR(65);
  SET @v = MEDIAN(AMOUNT);
  SELECT VALUE FROM USER_TABLES;
  SELECT A || B FROM T_DATA ORDER BY A NULLS LAST;
  SELECT A FROM T_ONE MINUS SELECT A FROM T_TWO;
  INSERT ALL INTO T_ONE VALUES (1) SELECT 1 FROM DUAL;
  UPDATE T_ONE SET A = 1 RETURNING A INTO @v;
  OPEN C_RESULT FOR SELECT A FROM T_ONE;
  FOR R_ROW IN C_ROWS LOOP NULL; END LOOP;
  GOTO FINISH;
  RAISE;
  CREATE GLOBAL TEMPORARY TABLE T_TEMP (ID NUMBER) ON COMMIT DELETE ROWS;
END
"""
        )

        self.assertTrue(
            {
                "oracle_concat_operator",
                "oracle_for_loop",
                "oracle_global_temporary",
                "oracle_goto",
                "oracle_insert_all",
                "oracle_minus",
                "oracle_median",
                "oracle_null_order",
                "oracle_on_commit_rows",
                "oracle_open_for",
                "oracle_raise",
                "oracle_returning_into",
                "oracle_to_number",
                "oracle_chr",
                "oracle_user_metadata",
            }.issubset({finding.code for finding in findings})
        )

    def test_structure_check_requires_matching_drop_create_name_and_parentheses(self):
        with TemporaryDirectory() as tmp_dir:
            path = Path(tmp_dir) / "P_EXPECTED.sql"
            path.write_text(
                """DELIMITER $$
DROP PROCEDURE IF EXISTS P_DROP$$
CREATE FUNCTION P_OTHER
RETURNS BIGINT
BEGIN
  RETURN 1;
END$$
DELIMITER ;
""",
                encoding="utf-8",
            )

            errors = validate_output_structure(path)

        self.assertTrue(any("expected object P_EXPECTED" in error for error in errors))
        self.assertTrue(any("parameter parentheses" in error for error in errors))
        self.assertTrue(any("DROP/CREATE" in error for error in errors))

    def test_structure_check_accepts_a_generated_routine_wrapper(self):
        with TemporaryDirectory() as tmp_dir:
            path = Path(tmp_dir) / "P_EXPECTED.sql"
            path.write_text(
                """DELIMITER $$
DROP PROCEDURE IF EXISTS P_EXPECTED$$
CREATE PROCEDURE P_EXPECTED()
BEGIN
  SELECT 1;
END$$
DELIMITER ;
""",
                encoding="utf-8",
            )

            errors = validate_output_structure(path)

        self.assertEqual([], errors)

    def test_structure_check_ignores_dash_sequences_in_literals_and_block_comments(self):
        with TemporaryDirectory() as tmp_dir:
            path = Path(tmp_dir) / "P_COMMENT.sql"
            path.write_text(
                """DELIMITER $$
DROP PROCEDURE IF EXISTS P_COMMENT$$
CREATE PROCEDURE P_COMMENT()
BEGIN
  /* --BLOCK */
  SELECT '--LITERAL';
  --BAD_COMMENT
  SELECT 1;
END$$
DELIMITER ;
""",
                encoding="utf-8",
            )

            errors = validate_output_structure(path)

        self.assertEqual(1, len(errors))
        self.assertIn("line(s): 7", errors[0])


if __name__ == "__main__":
    unittest.main()
