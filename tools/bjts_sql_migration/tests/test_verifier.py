from pathlib import Path
from tempfile import TemporaryDirectory
import unittest

from tools.bjts_sql_migration.verifier import (
    compare_manifest,
    load_manifest,
    scan_output_file,
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


if __name__ == "__main__":
    unittest.main()
