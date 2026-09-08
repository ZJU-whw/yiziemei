"""Static verification for generated BJTS MySQL routine scripts."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import json
from pathlib import Path
import re
from typing import Iterable


SOURCE_TO_OUTPUT = {
    "tl_admin": "mysql_tl_admin",
    "tl_bjts": "mysql_tl_bjts",
    "tl_tssh": "mysql_tl_tssh",
}


@dataclass(frozen=True)
class Finding:
    """One executable Oracle construct left in a generated script."""

    code: str
    line: int
    excerpt: str


ORACLE_PATTERNS: tuple[tuple[str, re.Pattern[str]], ...] = (
    ("oracle_create_or_replace", re.compile(r"\bCREATE\s+OR\s+REPLACE\b", re.I)),
    ("oracle_varchar2_type", re.compile(r"\bVARCHAR2\b", re.I)),
    (
        "oracle_number_type",
        re.compile(r"\bNUMBER\s*(?:\(\s*\d+(?:\s*,\s*-?\d+)?\s*\))?", re.I),
    ),
    ("oracle_rowtype", re.compile(r"%\s*ROWTYPE\b", re.I)),
    ("oracle_cursor_attribute", re.compile(r"%\s*(?:NOTFOUND|FOUND|ISOPEN)\b", re.I)),
    ("oracle_exception_block", re.compile(r"\bEXCEPTION\b", re.I)),
    ("oracle_assignment", re.compile(r":=")),
    ("oracle_schema_prefix", re.compile(r"\b(?:TL_ADMIN|TL_BJTS|TL_TSSH)\s*\.", re.I)),
    ("oracle_sequence", re.compile(r"\b[A-Z_$#][\w$#]*\s*\.\s*(?:NEXTVAL|CURRVAL)\b", re.I)),
    ("oracle_slash_terminator", re.compile(r"(?m)^\s*/\s*$")),
    ("oracle_nvl", re.compile(r"\bNVL2?\s*\(", re.I)),
    ("oracle_decode", re.compile(r"\bDECODE\s*\(", re.I)),
    ("oracle_to_char", re.compile(r"\bTO_CHAR\s*\(", re.I)),
    ("oracle_to_date", re.compile(r"\bTO_DATE\s*\(", re.I)),
    ("oracle_sysdate", re.compile(r"\b(?:SYSDATE|SYSTIMESTAMP)\b", re.I)),
    ("oracle_add_months", re.compile(r"\b(?:ADD_MONTHS|MONTHS_BETWEEN)\s*\(", re.I)),
    ("oracle_rownum", re.compile(r"\bROWNUM\b", re.I)),
    ("oracle_dual", re.compile(r"\bDUAL\b", re.I)),
    ("oracle_merge", re.compile(r"\bMERGE\s+INTO\b", re.I)),
    ("oracle_execute_immediate", re.compile(r"\bEXECUTE\s+IMMEDIATE\b", re.I)),
    ("oracle_dbms", re.compile(r"\bDBMS_[A-Z0-9_$#]+", re.I)),
    ("oracle_sql_attribute", re.compile(r"\bSQL\s*%\s*(?:ROWCOUNT|FOUND|NOTFOUND)\b", re.I)),
    ("oracle_next_day", re.compile(r"\bNEXT_DAY\s*\(", re.I)),
    ("oracle_sys_guid", re.compile(r"\bSYS_GUID\s*\(", re.I)),
    ("oracle_wm_concat", re.compile(r"\bWM_CONCAT\s*\(", re.I)),
    ("oracle_trunc", re.compile(r"\bTRUNC\s*\(", re.I)),
    (
        "oracle_raise_application_error",
        re.compile(r"\bRAISE_APPLICATION_ERROR\s*\(", re.I),
    ),
    ("oracle_pragma", re.compile(r"\bPRAGMA\b", re.I)),
    ("oracle_exit_when", re.compile(r"\bEXIT\s+WHEN\b", re.I)),
    ("oracle_exit", re.compile(r"\bEXIT\s*;", re.I)),
    ("oracle_continue", re.compile(r"\bCONTINUE\s*;", re.I)),
    ("oracle_tuple_update", re.compile(r"\bSET\s*\(", re.I)),
    ("oracle_rowid", re.compile(r"\bROWID\b", re.I)),
    ("oracle_pipe_row", re.compile(r"\bPIPE\s+ROW\s*\(", re.I)),
    ("oracle_pipelined", re.compile(r"\bPIPELINED\b", re.I)),
    ("oracle_bulk_collect", re.compile(r"\bBULK\s+COLLECT\b", re.I)),
    ("oracle_forall", re.compile(r"\bFORALL\b", re.I)),
    ("oracle_type_reference", re.compile(r"%\s*TYPE\b", re.I)),
    ("oracle_connect_by", re.compile(r"\bCONNECT\s+BY\b", re.I)),
    ("oracle_start_with", re.compile(r"\bSTART\s+WITH\b", re.I)),
    ("oracle_outer_join", re.compile(r"\(\s*\+\s*\)", re.I)),
    ("oracle_concat_operator", re.compile(r"\|\|")),
    ("oracle_to_number", re.compile(r"\bTO_NUMBER\s*\(", re.I)),
    ("oracle_median", re.compile(r"\bMEDIAN\s*\(", re.I)),
    ("oracle_to_timestamp", re.compile(r"\bTO_TIMESTAMP(?:_TZ)?\s*\(", re.I)),
    ("oracle_chr", re.compile(r"\bCHR\s*\(", re.I)),
    ("oracle_byte_string_function", re.compile(r"\b(?:LENGTHB|INSTRB|SUBSTRB)\s*\(", re.I)),
    ("oracle_bitand", re.compile(r"\bBITAND\s*\(", re.I)),
    ("oracle_sys_context", re.compile(r"\bSYS_CONTEXT\s*\(", re.I)),
    ("oracle_hash", re.compile(r"\b(?:ORA_HASH|STANDARD_HASH)\s*\(", re.I)),
    ("oracle_nlssort", re.compile(r"\bNLSSORT\s*\(", re.I)),
    ("oracle_empty_lob", re.compile(r"\bEMPTY_[CB]LOB\s*\(", re.I)),
    ("oracle_interval_function", re.compile(r"\bNUMTO(?:DS|YM)INTERVAL\s*\(", re.I)),
    ("oracle_minus", re.compile(r"\bMINUS\b", re.I)),
    ("oracle_null_order", re.compile(r"\bNULLS\s+(?:FIRST|LAST)\b", re.I)),
    ("oracle_fetch_first", re.compile(r"\bFETCH\s+FIRST\b", re.I)),
    ("oracle_insert_all", re.compile(r"\bINSERT\s+ALL\b", re.I)),
    ("oracle_returning_into", re.compile(r"\bRETURNING\b[^;]*\bINTO\b", re.I)),
    ("oracle_named_argument", re.compile(r"=>")),
    ("oracle_ref_cursor", re.compile(r"\bREF\s+CURSOR\b", re.I)),
    ("oracle_open_for", re.compile(r"\bOPEN\s+[A-Z_$#][\w$#]*\s+FOR\b", re.I)),
    ("oracle_for_loop", re.compile(r"\bFOR\s+[A-Z_$#][\w$#]*\s+IN\b", re.I)),
    ("oracle_table_function", re.compile(r"\bTABLE\s*\(", re.I)),
    ("oracle_goto", re.compile(r"\bGOTO\b", re.I)),
    ("oracle_raise", re.compile(r"\bRAISE\b", re.I)),
    (
        "oracle_global_temporary",
        re.compile(r"\bGLOBAL\s+TEMPORARY\b", re.I),
    ),
    (
        "oracle_on_commit_rows",
        re.compile(r"\bON\s+COMMIT\s+(?:DELETE|PRESERVE)\s+ROWS\b", re.I),
    ),
    (
        "oracle_user_metadata",
        re.compile(r"\b(?:USER|ALL|DBA)_(?:TABLES|OBJECTS|SOURCE|SEQUENCES)\b", re.I),
    ),
    ("oracle_date_literal", re.compile(r"\bDATE\s*'", re.I)),
    ("oracle_pls_integer", re.compile(r"\b(?:PLS_INTEGER|BINARY_INTEGER)\b", re.I)),
    ("oracle_collection_extend", re.compile(r"\.\s*EXTEND\b", re.I)),
)


def _manifest_path(repo_root: Path) -> Path:
    return repo_root / "tools" / "bjts_sql_migration" / "source_manifest.json"


def load_manifest(repo_root: Path | None = None) -> dict[str, list[str]]:
    """Load the committed, deterministic list of Oracle source basenames."""

    if repo_root is None:
        repo_root = Path(__file__).resolve().parents[2]
    data = json.loads(_manifest_path(repo_root).read_text(encoding="utf-8"))
    if set(data) != set(SOURCE_TO_OUTPUT):
        raise ValueError("source manifest must contain exactly the three source schemas")
    for source_name, filenames in data.items():
        if filenames != sorted(set(filenames)):
            raise ValueError(f"manifest entry {source_name} is not sorted and unique")
    return data


def compare_manifest(repo_root: Path) -> list[str]:
    """Return human-readable source/output filename mismatches."""

    errors: list[str] = []
    manifest = load_manifest(repo_root)
    for source_name, output_name in SOURCE_TO_OUTPUT.items():
        output_dir = repo_root / "bjts" / output_name
        actual = sorted(path.name for path in output_dir.glob("*.sql")) if output_dir.is_dir() else []
        expected = manifest[source_name]
        missing = sorted(set(expected) - set(actual))
        extra = sorted(set(actual) - set(expected))
        if missing:
            errors.append(f"{output_name}: missing {len(missing)} files: {', '.join(missing)}")
        if extra:
            errors.append(f"{output_name}: unexpected {len(extra)} files: {', '.join(extra)}")
    return errors


def mask_non_executable(sql: str) -> str:
    """Replace comments and single-quoted literals with spaces, preserving lines."""

    result = list(sql)
    index = 0
    length = len(sql)
    state = "code"
    while index < length:
        char = sql[index]
        following = sql[index + 1] if index + 1 < length else ""

        if state == "code":
            if char == "'":
                result[index] = " "
                state = "string"
            elif char == "-" and following == "-":
                result[index] = result[index + 1] = " "
                index += 1
                state = "line_comment"
            elif char == "/" and following == "*":
                result[index] = result[index + 1] = " "
                index += 1
                state = "block_comment"
        elif state == "string":
            if char == "\n":
                result[index] = "\n"
            else:
                result[index] = " "
            if char == "'":
                if following == "'":
                    result[index + 1] = " "
                    index += 1
                else:
                    state = "code"
        elif state == "line_comment":
            if char == "\n":
                result[index] = "\n"
                state = "code"
            else:
                result[index] = " "
        elif state == "block_comment":
            if char == "\n":
                result[index] = "\n"
            else:
                result[index] = " "
            if char == "*" and following == "/":
                result[index + 1] = " "
                index += 1
                state = "code"
        index += 1
    return "".join(result)


def _line_number(text: str, offset: int) -> int:
    return text.count("\n", 0, offset) + 1


def _invalid_mysql_dash_comment_lines(sql: str) -> list[int]:
    """Return executable ``--text`` lines, ignoring literals and block comments."""

    lines: list[int] = []
    index = 0
    line = 1
    state = "code"
    while index < len(sql):
        char = sql[index]
        following = sql[index + 1] if index + 1 < len(sql) else ""

        if char == "\n":
            line += 1
            if state == "line_comment":
                state = "code"
            index += 1
            continue

        if state == "code":
            if char == "'":
                state = "string"
            elif char == "/" and following == "*":
                state = "block_comment"
                index += 1
            elif char == "-" and following == "-":
                comment_text = sql[index + 2] if index + 2 < len(sql) else ""
                if comment_text and not comment_text.isspace():
                    lines.append(line)
                state = "line_comment"
                index += 1
        elif state == "string":
            if char == "\\" and following:
                index += 1
            elif char == "'":
                if following == "'":
                    index += 1
                else:
                    state = "code"
        elif state == "block_comment" and char == "*" and following == "/":
            state = "code"
            index += 1

        index += 1
    return lines


def scan_output_file(path: Path) -> list[Finding]:
    """Find known Oracle-only constructs in executable SQL segments."""

    text = path.read_text(encoding="utf-8")
    executable = mask_non_executable(text)
    findings: list[Finding] = []
    for code, pattern in ORACLE_PATTERNS:
        for match in pattern.finditer(executable):
            line = _line_number(executable, match.start())
            source_line = text.splitlines()[line - 1].strip()
            findings.append(Finding(code=code, line=line, excerpt=source_line[:240]))
    return findings


_ROUTINE_IDENTIFIER = r"`?([A-Z_](?:[A-Z0-9_]|\$(?!\$))*)`?"
_CREATE_ROUTINE = re.compile(
    rf"\bCREATE\s+(PROCEDURE|FUNCTION)\s+{_ROUTINE_IDENTIFIER}", re.I
)
_DROP_ROUTINE = re.compile(
    rf"\bDROP\s+(PROCEDURE|FUNCTION)\s+IF\s+EXISTS\s+{_ROUTINE_IDENTIFIER}",
    re.I,
)


def validate_output_structure(path: Path) -> list[str]:
    """Check one generated script's routine wrapper and object identity."""

    text = path.read_text(encoding="utf-8")
    executable = mask_non_executable(text)
    errors: list[str] = []
    expected_name = path.stem.upper()

    create_matches = list(_CREATE_ROUTINE.finditer(executable))
    if len(create_matches) != 1:
        errors.append(f"expected exactly one CREATE routine, found {len(create_matches)}")
        return errors

    create_match = create_matches[0]
    create_type = create_match.group(1).upper()
    create_name = create_match.group(2).upper()
    if create_name != expected_name:
        errors.append(
            f"expected object {expected_name} from filename, found {create_name}"
        )

    after_name = executable[create_match.end() :]
    if not re.match(r"\s*\(", after_name):
        errors.append(f"{create_name}: missing parameter parentheses after routine name")

    drop_matches = list(_DROP_ROUTINE.finditer(executable))
    if len(drop_matches) != 1:
        errors.append(f"expected exactly one DROP routine, found {len(drop_matches)}")
    else:
        drop_type = drop_matches[0].group(1).upper()
        drop_name = drop_matches[0].group(2).upper()
        if (drop_type, drop_name) != (create_type, create_name):
            errors.append(
                "DROP/CREATE mismatch: "
                f"DROP {drop_type} {drop_name}, CREATE {create_type} {create_name}"
            )

    body = executable[create_match.end() :]
    if create_type == "FUNCTION":
        if not re.search(r"\bRETURNS\b", body, re.I):
            errors.append(f"{create_name}: FUNCTION is missing RETURNS")
        if not re.search(r"\bRETURN(?=\s|\()[ \t\r\n]*(?!;)[^;]+;", body, re.I):
            errors.append(f"{create_name}: FUNCTION is missing a value RETURN")
    elif re.search(r"\bRETURN\b", body, re.I):
        errors.append(f"{create_name}: PROCEDURE contains executable RETURN")

    invalid_comment_lines = _invalid_mysql_dash_comment_lines(text)
    if invalid_comment_lines:
        rendered_lines = ", ".join(str(line) for line in invalid_comment_lines)
        errors.append(
            "MySQL -- comments must be followed by whitespace "
            f"(line(s): {rendered_lines})"
        )

    return errors


def _iter_output_files(repo_root: Path, schema: str | None) -> Iterable[Path]:
    source_names = [schema] if schema else list(SOURCE_TO_OUTPUT)
    for source_name in source_names:
        if source_name not in SOURCE_TO_OUTPUT:
            raise ValueError(f"unknown schema: {source_name}")
        yield from sorted((repo_root / "bjts" / SOURCE_TO_OUTPUT[source_name]).glob("*.sql"))


def verify(repo_root: Path, schema: str | None = None) -> list[str]:
    """Run all server-independent checks and return errors."""

    errors = compare_manifest(repo_root)
    for path in _iter_output_files(repo_root, schema):
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError as exc:
            errors.append(f"{path}: not UTF-8: {exc}")
            continue
        if not text.strip():
            errors.append(f"{path}: empty output")
            continue
        upper = text.upper()
        if "DELIMITER $$" not in upper or "DELIMITER ;" not in upper:
            errors.append(f"{path}: missing MySQL delimiter wrapper")
        for structure_error in validate_output_structure(path):
            errors.append(f"{path}: {structure_error}")
        for finding in scan_output_file(path):
            errors.append(f"{path}:{finding.line}: {finding.code}: {finding.excerpt}")
    return errors


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, default=Path.cwd())
    parser.add_argument("--schema", choices=sorted(SOURCE_TO_OUTPUT))
    args = parser.parse_args(argv)
    errors = verify(args.repo_root.resolve(), args.schema)
    if errors:
        for error in errors:
            print(error)
        print(f"static verification failed: {len(errors)} issue(s)")
        return 1
    checked = sum(1 for _ in _iter_output_files(args.repo_root.resolve(), args.schema))
    print(f"{checked}/{checked} output files verified; 0 executable Oracle residue findings")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
