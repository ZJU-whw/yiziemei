from pathlib import Path
import re
import unittest


REPO_ROOT = Path(__file__).resolve().parents[3]
EXTRA_SQL = REPO_ROOT / "bjts" / "mysql_added" / "mysql_extra.sql"
OUTPUT_LIST = REPO_ROOT / "bjts" / "mysql_added" / "SetOutputFuncList.txt"
OUTPUT_DIRS = (
    REPO_ROOT / "bjts" / "mysql_tl_admin",
    REPO_ROOT / "bjts" / "mysql_tl_bjts",
    REPO_ROOT / "bjts" / "mysql_tl_tssh",
)

EXPECTED_FUNCTION_PROCEDURES = [
    "FUNC_GET_RANDOM_SBR",
    "FUNC_GET_SBHZXX",
    "FUNC_GET_SBHZXX_QXSWJG",
    "FUNC_GET_SBHZXX_TEST",
    "FUNC_GET_SBHZXX_TSSWJG",
    "FUNC_GET_SBLIST",
    "FUNC_GET_SBLIST_SORT",
    "FUNC_GET_SBLIST_SORT_QXSWJG",
    "FUNC_GET_SBLIST_SORT_TEST",
    "FUNC_GET_SBLIST_SORT_TSSWJG",
    "FUNC_GET_WJDR_COUNT",
    "FUNC_GET_WJDR_SBLIST",
    "FUNC_GET_WJDR_SBLIST_TEST",
    "FUNC_GET_XJ_SWJG",
    "FUNC_SHZS_RWWP",
    "FUNC_SHZS_RWWP_BAK20250609",
    "FUNC_SHZS_RWWP_BAK_OLD2025",
    "FUNC_STRSPLIT",
    "FUNC_XXBD_QUERY_CPCODEKZ",
    "F_JKGL_JKM_PD",
    "F_MY_STDAVG_TMPTB",
    "F_WLGL_EXTRACT_PLATE",
    "TEMP_DATA_INIT",
]

EXPECTED_SEEDS = {
    "SEQ_DEAL_TKGZ": 11959,
    "SEQ_FXGL_DATA_ZXZB": 96139,
    "SEQ_FXGL_SZ_SPFXJH": 489082,
    "SEQ_GS_TB_NSRDZDAH": 219970,
    "SEQ_JKGL_DATA_TJ_ZBU_CKGB": 18094660,
    "SEQ_JKGL_DATA_TJ_ZBU_CKKA": 9491620,
    "SEQ_JKGL_DATA_TJ_ZBU_CKSP": 17759240,
    "SEQ_JKGL_DATA_TJ_ZBU_DZGF": 3728720,
    "SEQ_JKGL_DATA_TJ_ZBU_DZSPJX": 115360,
    "SEQ_JKGL_DATA_TJ_ZBU_DZSPXX": 32180,
    "SEQ_JKGL_DATA_TJ_ZBU_DZXF": 4828980,
    "SEQ_JKGL_DATA_TJ_ZBU_TSGH": 17807380,
    "SEQ_JKGL_DATA_TJ_ZBU_TSSP": 15818820,
    "SEQ_JKGL_QSPJ_CKSP": 448980,
    "SEQ_MSG_PUSH_DATA": 157819,
    "SEQ_MSG_PUSH_PLAN": 166080,
    "SEQ_TB_DTBSJ_ID": 23893952,
    "SEQ_TB_TBPC": 34395504,
    "SEQ_TJBB_SB_JYXX": 16940,
    "SEQ_XXBD_SHQ_YDID": 16085620,
    "SEQ_YJ_DATA_YJXX": 406200,
}


def literal_sequence_calls() -> set[str]:
    calls: set[str] = set()
    pattern = re.compile(r"SEQ_NEXTVAL\s*\(\s*'([^']+)'\s*\)", re.I)
    for output_dir in OUTPUT_DIRS:
        for path in output_dir.glob("*.sql"):
            calls.update(match.upper() for match in pattern.findall(path.read_text(encoding="utf-8")))
    return calls


def parsed_seed_values(sql: str) -> dict[str, int]:
    return {
        name.upper(): int(value)
        for name, value in re.findall(r"\('([A-Z0-9_$#]+)'\s*,\s*(\d+)\)", sql, re.I)
    }


class ExtraObjectTests(unittest.TestCase):
    def test_sequence_table_and_atomic_allocator_are_defined(self):
        sql = EXTRA_SQL.read_text(encoding="utf-8")

        self.assertRegex(sql, r"(?is)CREATE TABLE IF NOT EXISTS sys_sequence\s*\(")
        self.assertRegex(sql, r"(?is)PRIMARY KEY\s*\(SEQ_NAME\)")
        self.assertRegex(sql, r"(?is)CREATE FUNCTION SEQ_NEXTVAL\s*\(")
        self.assertRegex(sql, r"(?is)ON DUPLICATE KEY UPDATE")
        self.assertRegex(sql, r"(?is)LAST_INSERT_ID\s*\(SEQ_VALUE\s*\+\s*1\)")

    def test_seed_values_are_one_before_exported_next_values(self):
        sql = EXTRA_SQL.read_text(encoding="utf-8")

        self.assertEqual(EXPECTED_SEEDS, parsed_seed_values(sql))
        self.assertEqual(set(EXPECTED_SEEDS), literal_sequence_calls())

    def test_output_function_list_is_complete_sorted_and_unique(self):
        names = OUTPUT_LIST.read_text(encoding="utf-8").splitlines()

        self.assertEqual(EXPECTED_FUNCTION_PROCEDURES, names)
        self.assertEqual(sorted(set(names), key=str.upper), names)

    def test_every_listed_object_is_created_as_a_procedure(self):
        definitions: dict[str, str] = {}
        pattern = re.compile(r"\bCREATE\s+(PROCEDURE|FUNCTION)\s+([A-Z0-9_$#]+)", re.I)
        for output_dir in OUTPUT_DIRS:
            for path in output_dir.glob("*.sql"):
                match = pattern.search(path.read_text(encoding="utf-8"))
                self.assertIsNotNone(match, path)
                definitions[match.group(2).upper()] = match.group(1).upper()

        for name in EXPECTED_FUNCTION_PROCEDURES:
            self.assertEqual("PROCEDURE", definitions[name], name)

    def test_legacy_sequence_function_delegates_without_transaction_control(self):
        path = REPO_ROOT / "bjts" / "mysql_tl_bjts" / "F_SEQ_NEXTVAL_ADMIN.sql"
        sql = path.read_text(encoding="utf-8")

        self.assertRegex(sql, r"(?is)CREATE FUNCTION F_SEQ_NEXTVAL_ADMIN")
        self.assertRegex(sql, r"(?is)RETURN\s+SEQ_NEXTVAL\s*\(UPPER\(P_TABLENAME\)\)")
        self.assertNotRegex(sql, r"(?i)\bCOMMIT\b")
        self.assertNotRegex(sql, r"(?i)\bPRAGMA\b")


if __name__ == "__main__":
    unittest.main()
