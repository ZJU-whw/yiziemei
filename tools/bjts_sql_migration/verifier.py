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
