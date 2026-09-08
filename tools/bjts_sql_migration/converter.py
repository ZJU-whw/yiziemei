"""Repeatable first-pass conversion of BJTS Oracle routines to MySQL 8.0."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
import re
from typing import Iterator

from .verifier import SOURCE_TO_OUTPUT, load_manifest, mask_non_executable


@dataclass(frozen=True)
class ConversionResult:
    sql: str
    source_object_type: str
    target_object_type: str
    object_name: str
    warnings: list[str]


@dataclass(frozen=True)
class Segment:
    executable: bool
    text: str


ROUTINE_PATTERN = re.compile(
    r"\bCREATE\s+OR\s+REPLACE\s+(PROCEDURE|FUNCTION)\s+([A-Z_$#][\w$#]*)",
    re.I,
)

PROTECTED_PREFIX = "__BJTS_PROTECTED_"
ORACLE_FUNCTION_NAMES = (
    "MONTHS_BETWEEN",
    "ADD_MONTHS",
    "TO_NUMBER",
    "TO_CHAR",
    "TO_DATE",
    "NVL2",
    "NVL",
    "DECODE",
    "TRUNC",
)


def _segments(text: str) -> Iterator[Segment]:
    """Split SQL into executable and protected comment/string segments."""

    start = 0
    index = 0
    length = len(text)
    while index < length:
        following = text[index + 1] if index + 1 < length else ""
        if text[index] == "'":
            if start < index:
                yield Segment(True, text[start:index])
            protected_start = index
            index += 1
            while index < length:
                if text[index] == "'":
                    if index + 1 < length and text[index + 1] == "'":
                        index += 2
                        continue
                    index += 1
                    break
                index += 1
            yield Segment(False, text[protected_start:index])
            start = index
            continue
        if text[index] == "-" and following == "-":
            if start < index:
                yield Segment(True, text[start:index])
            protected_start = index
            newline = text.find("\n", index + 2)
            index = length if newline < 0 else newline
            yield Segment(False, text[protected_start:index])
            start = index
            continue
        if text[index] == "/" and following == "*":
            if start < index:
                yield Segment(True, text[start:index])
            protected_start = index
            close = text.find("*/", index + 2)
            index = length if close < 0 else close + 2
            yield Segment(False, text[protected_start:index])
            start = index
            continue
        index += 1
    if start < length:
        yield Segment(True, text[start:])


def _number_type(match: re.Match[str]) -> str:
    precision = match.group(1)
    scale = match.group(2)
    if precision is None:
        return "DECIMAL(38,10)"
    p_value = int(precision)
    s_value = int(scale) if scale is not None else 0
    if s_value == 0 and p_value <= 18:
        return "BIGINT"
    return f"DECIMAL({p_value},{s_value})"


def _varchar2_type(match: re.Match[str]) -> str:
    length = match.group(1)
    return f"VARCHAR({length})" if length else "VARCHAR(4000)"


def _transform_assignments(code: str) -> str:
    statement_start = re.compile(
        r"(?im)(^[ \t]*|;[ \t]*|\bTHEN[ \t]+|\bELSE[ \t]+)"
        r"([A-Z_$#][\w$#]*(?:\.[A-Z_$#][\w$#]*)?)\s*:="
    )

    def replacement(match: re.Match[str]) -> str:
        return f"{match.group(1)}SET {match.group(2)} ="

    return statement_start.sub(replacement, code)


def _protect(text: str) -> tuple[str, dict[str, str]]:
    replacements: dict[str, str] = {}
    parts: list[str] = []
    for segment in _segments(text):
        if segment.executable:
            parts.append(segment.text)
            continue
        marker = f"{PROTECTED_PREFIX}{len(replacements):06d}__"
        replacements[marker] = segment.text
        parts.append(marker)
    return "".join(parts), replacements


def _restore(text: str, replacements: dict[str, str]) -> str:
    for marker, original in replacements.items():
        text = text.replace(marker, original)
    return text


def _matching_parenthesis(text: str, opening: int) -> int | None:
    depth = 0
    for index in range(opening, len(text)):
        if text[index] == "(":
            depth += 1
        elif text[index] == ")":
            depth -= 1
            if depth == 0:
                return index
    return None


def _split_arguments(text: str) -> list[str]:
    arguments: list[str] = []
    depth = 0
    start = 0
    for index, char in enumerate(text):
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
        elif char == "," and depth == 0:
            arguments.append(text[start:index].strip())
            start = index + 1
    arguments.append(text[start:].strip())
    return arguments


def _literal(marker_or_sql: str, replacements: dict[str, str]) -> str | None:
    value = replacements.get(marker_or_sql.strip())
    if value and value.startswith("'") and value.endswith("'"):
        return value[1:-1].replace("''", "'")
    return None


def _sql_literal(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def _mysql_datetime_format(oracle_format: str) -> str:
    token_pattern = re.compile(
        r"HH24|HH12|YYYY|RRRR|MONTH|MON|MI|SS|FF6|FF|YY|MM|DD|HH|AM|PM",
        re.I,
    )
    mapping = {
        "HH24": "%H",
        "HH12": "%h",
        "YYYY": "%Y",
        "RRRR": "%Y",
        "MONTH": "%M",
        "MON": "%b",
        "MI": "%i",
        "SS": "%s",
        "FF6": "%f",
        "FF": "%f",
        "YY": "%y",
        "MM": "%m",
        "DD": "%d",
        "HH": "%h",
        "AM": "%p",
        "PM": "%p",
    }
    return token_pattern.sub(lambda match: mapping[match.group(0).upper()], oracle_format)


def _function_replacement(
    name: str,
    arguments: list[str],
    replacements: dict[str, str],
) -> str | None:
    upper_name = name.upper()
    if upper_name == "NVL" and len(arguments) == 2:
        return f"IFNULL({arguments[0]}, {arguments[1]})"
    if upper_name == "NVL2" and len(arguments) == 3:
        return (
            f"(CASE WHEN {arguments[0]} IS NOT NULL "
            f"THEN {arguments[1]} ELSE {arguments[2]} END)"
        )
    if upper_name == "DECODE" and len(arguments) >= 3:
        expression = arguments[0]
        pairs = arguments[1:]
        default = "NULL"
        if len(pairs) % 2 == 1:
            default = pairs[-1]
            pairs = pairs[:-1]
        clauses = " ".join(
            f"WHEN {pairs[index]} THEN {pairs[index + 1]}"
            for index in range(0, len(pairs), 2)
        )
        return f"(CASE {expression} {clauses} ELSE {default} END)"
    if upper_name == "ADD_MONTHS" and len(arguments) == 2:
        return f"DATE_ADD({arguments[0]}, INTERVAL {arguments[1]} MONTH)"
    if upper_name == "MONTHS_BETWEEN" and len(arguments) == 2:
        return f"TIMESTAMPDIFF(MONTH, {arguments[1]}, {arguments[0]})"
    if upper_name == "TO_NUMBER" and arguments:
        return f"CAST({arguments[0]} AS DECIMAL(65,30))"
    if upper_name in {"TO_DATE", "TO_CHAR"} and arguments:
        if len(arguments) == 1:
            target = "DATETIME" if upper_name == "TO_DATE" else "CHAR"
            return f"CAST({arguments[0]} AS {target})"
        oracle_format = _literal(arguments[1], replacements)
        if oracle_format is None:
            function = "STR_TO_DATE" if upper_name == "TO_DATE" else "DATE_FORMAT"
            return f"{function}({arguments[0]}, {arguments[1]})"
        if upper_name == "TO_CHAR" and re.fullmatch(r"FM?0+", oracle_format, re.I):
            width = len(re.sub(r"^FM", "", oracle_format, flags=re.I))
            return f"LPAD(CAST({arguments[0]} AS CHAR), {width}, '0')"
        mysql_format = _sql_literal(_mysql_datetime_format(oracle_format))
        function = "STR_TO_DATE" if upper_name == "TO_DATE" else "DATE_FORMAT"
        return f"{function}({arguments[0]}, {mysql_format})"
    if upper_name == "TRUNC" and arguments:
        if len(arguments) == 2:
            oracle_format = _literal(arguments[1], replacements)
            if oracle_format and oracle_format.upper() in {"YYYY", "YEAR"}:
                return f"MAKEDATE(YEAR({arguments[0]}), 1)"
            if oracle_format and oracle_format.upper() in {"MM", "MONTH"}:
                return (
                    f"CAST(DATE_FORMAT({arguments[0]}, '%Y-%m-01') AS DATETIME)"
                )
            if oracle_format and oracle_format.upper() in {"DD", "DAY"}:
                return f"DATE({arguments[0]})"
            return f"TRUNCATE({arguments[0]}, {arguments[1]})"
        return f"TRUNCATE({arguments[0]}, 0)"
    return None


def _rewrite_function_calls(
    text: str,
    replacements: dict[str, str],
) -> str:
    names = "|".join(re.escape(name) for name in ORACLE_FUNCTION_NAMES)
    pattern = re.compile(rf"\b({names})\s*\(", re.I)
    search_from = 0
    while True:
        match = pattern.search(text, search_from)
        if not match:
            return text
        opening = text.find("(", match.start())
        closing = _matching_parenthesis(text, opening)
        if closing is None:
            search_from = match.end()
            continue
        inner = _rewrite_function_calls(text[opening + 1 : closing], replacements)
        arguments = _split_arguments(inner)
        replacement = _function_replacement(match.group(1), arguments, replacements)
        if replacement is None:
            search_from = closing + 1
            continue
        text = text[: match.start()] + replacement + text[closing + 1 :]
        search_from = match.start() + len(replacement)


def _transform_executable(code: str) -> str:
    code = re.sub(r"\b(?:TL_ADMIN|TL_BJTS|TL_TSSH)\s*\.", "", code, flags=re.I)
    code = re.sub(
        r"\b([A-Z_$#][\w$#]*)\s*\.\s*NEXTVAL\b",
        lambda match: f"SEQ_NEXTVAL('{match.group(1).upper()}')",
        code,
        flags=re.I,
    )
    code = re.sub(
        r"\b([A-Z_$#][\w$#]*)\s*\.\s*CURRVAL\b",
        lambda match: f"SEQ_CURRVAL('{match.group(1).upper()}')",
        code,
        flags=re.I,
    )
    code = re.sub(r"\bSQL\s*%\s*ROWCOUNT\b", "ROW_COUNT()", code, flags=re.I)
    code = re.sub(
        r"\bNUMBER(?:\s*\(\s*(\d+)(?:\s*,\s*(-?\d+))?\s*\))?",
        _number_type,
        code,
        flags=re.I,
    )
    code = re.sub(
        r"\bVARCHAR2(?:\s*\(\s*(\d+)\s*(?:BYTE|CHAR)?\s*\))?",
        _varchar2_type,
        code,
        flags=re.I,
    )
    code = re.sub(r"\bELSIF\b", "ELSEIF", code, flags=re.I)
    code = re.sub(r"\bSYSTIMESTAMP\b", "CURRENT_TIMESTAMP(6)", code, flags=re.I)
    code = re.sub(r"\bSYSDATE\b", "CURRENT_TIMESTAMP", code, flags=re.I)
    code = re.sub(r"[ \t]+\bFROM\s+DUAL\b", "", code, flags=re.I)
    code = _transform_assignments(code)
    return code


def convert_fragment(text: str) -> str:
    """Convert safe common constructs without touching comments or literals."""

    protected, replacements = _protect(text)
    converted = _rewrite_function_calls(protected, replacements)
    converted = _transform_executable(converted)
    return _restore(converted, replacements)


def _routine_metadata(source_text: str) -> tuple[str, str]:
    executable = mask_non_executable(source_text)
    match = ROUTINE_PATTERN.search(executable)
    if not match:
        raise ValueError("source does not contain one CREATE OR REPLACE routine")
    return match.group(1).upper(), match.group(2).upper()


def _must_be_procedure(source_text: str, object_name: str) -> bool:
    if object_name == "F_SEQ_NEXTVAL_ADMIN":
        return False
    executable = mask_non_executable(source_text)
    collection_return = re.search(
        r"\bRETURN\s+(?:TYPE_TB_[A-Z0-9_$#]*|STRSPLIT_TYPE)\b",
        executable,
        re.I,
    )
    forbidden = re.search(
        r"\b(?:PIPELINED|EXECUTE\s+IMMEDIATE|COMMIT|ROLLBACK)\b|"
        r"\bPRAGMA\s+AUTONOMOUS_TRANSACTION\b",
        executable,
        re.I,
    )
    header_end = re.search(r"\b(?:IS|AS)\b", executable, re.I)
    header = executable[: header_end.start()] if header_end else executable[:1000]
    output_parameter = re.search(r"\bOUT\b", header, re.I)
    return bool(collection_return or forbidden or output_parameter)


def _routine_marker(executable: str, start: int) -> re.Match[str]:
    marker_pattern = re.compile(r"\b(?:IS|AS)\b", re.I)
    depth = 0
    index = start
    while index < len(executable):
        char = executable[index]
        if char == "(":
            depth += 1
        elif char == ")":
            depth = max(0, depth - 1)
        elif depth == 0:
            marker = marker_pattern.match(executable, index)
            if marker:
                return marker
        index += 1
    raise ValueError("routine header has no IS or AS marker")


def _convert_parameter_modes(header: str, target_object_type: str) -> str:
    protected, replacements = _protect(header)
    protected = re.sub(r"\bDATE\b", "DATETIME", protected, flags=re.I)
    if target_object_type == "FUNCTION":
        protected = re.sub(
            r"\b([A-Z_$#][\w$#]*)\s+IN\s+(?=(?:BIGINT|DECIMAL|VARCHAR|CHAR|DATE|DATETIME|INTEGER)\b)",
            r"\1 ",
            protected,
            flags=re.I,
        )
    else:
        protected = re.sub(
            r"\b([A-Z_$#][\w$#]*)\s+IN\s+OUT\s+",
            r"INOUT \1 ",
            protected,
            flags=re.I,
        )
        protected = re.sub(
            r"\b([A-Z_$#][\w$#]*)\s+OUT\s+",
            r"OUT \1 ",
            protected,
            flags=re.I,
        )
        protected = re.sub(
            r"\b([A-Z_$#][\w$#]*)\s+IN\s+",
            r"IN \1 ",
            protected,
            flags=re.I,
        )
    return _restore(protected, replacements)


def _first_executable_offset(text: str) -> int | None:
    masked = mask_non_executable(text)
    match = re.search(r"\S", masked)
    return match.start() if match else None


def _convert_declaration_statement(statement: str) -> str:
    offset = _first_executable_offset(statement)
    if offset is None:
        return statement
    leading = statement[:offset]
    declaration = statement[offset:]
    executable = mask_non_executable(declaration)
    if re.match(r"TYPE\s+\w+\s+IS\s+REF\s+CURSOR\b", executable, re.I):
        return leading + "-- Oracle REF CURSOR type removed; target uses a result set"
    if re.match(r"CURSOR\s+", executable, re.I):
        declaration = re.sub(r"^CURSOR\s+", "DECLARE ", declaration, count=1, flags=re.I)
        declaration = re.sub(r"\bIS\b", "CURSOR FOR", declaration, count=1, flags=re.I)
        return leading + declaration
    declaration = re.sub(r"\bCONSTANT\b", "", declaration, count=1, flags=re.I)
    declaration = re.sub(r":=", " DEFAULT ", declaration, count=1)
    declaration = re.sub(r"\s+DEFAULT\s+", " DEFAULT ", declaration, count=1, flags=re.I)
    declaration = re.sub(r"\bDATE\b", "DATETIME", declaration, count=1, flags=re.I)
    return leading + "DECLARE " + declaration


def _convert_declarations(declarations: str) -> str:
    protected, replacements = _protect(declarations)
    chunks = protected.split(";")
    converted: list[str] = []
    for index, chunk in enumerate(chunks):
        restored = _restore(chunk, replacements)
        converted.append(_convert_declaration_statement(restored))
        if index < len(chunks) - 1:
            converted.append(";")
    return "".join(converted)


def _return_type(header: str) -> tuple[int, str]:
    masked = mask_non_executable(header)
    matches = list(re.finditer(r"\bRETURN\b", masked, re.I))
    if not matches:
        raise ValueError("function header has no return type")
    match = matches[-1]
    return_sql = masked[match.end() :].strip()
    return_sql = re.sub(r"\s+", " ", return_sql)
    if return_sql.upper() == "DATE":
        return_sql = "DATETIME"
    return match.start(), return_sql


def _append_out_result_parameter(header: str, return_type: str) -> str:
    masked = mask_non_executable(header)
    closing = masked.rfind(")")
    if closing >= 0:
        opening = masked.find("(")
        separator = "" if not masked[opening + 1 : closing].strip() else ", "
        return header[:closing] + separator + f"OUT P_RESULT {return_type}" + header[closing:]
    return header.rstrip() + f"(OUT P_RESULT {return_type})"


def _rewrite_procedure_returns(body: str, scalar_result: bool) -> str:
    protected, replacements = _protect(body)
    if scalar_result:
        protected = re.sub(
            r"\bRETURN\s+([^;]+);",
            r"SET P_RESULT = \1; LEAVE routine_body;",
            protected,
            flags=re.I,
        )
    else:
        protected = re.sub(
            r"\bRETURN(?:\s+[^;]+)?\s*;",
            "LEAVE routine_body;",
            protected,
            flags=re.I,
        )
    protected = re.sub(
        r"(?im)(^[ \t]*|;[ \t]*|\bTHEN[ \t]+|\bELSE[ \t]+)NULL\s*;",
        r"\1DO 0;",
        protected,
    )
    return _restore(protected, replacements)


def _convert_routine_structure(
    converted: str,
    source_text: str,
    source_object_type: str,
    target_object_type: str,
    object_name: str,
) -> str:
    converted = re.sub(
        r"\bCREATE\s+OR\s+REPLACE\b",
        "CREATE",
        converted,
        count=1,
        flags=re.I,
    )
    if source_object_type != target_object_type:
        converted = re.sub(
            rf"(\bCREATE\s+){source_object_type}\b",
            rf"\1{target_object_type}",
            converted,
            count=1,
            flags=re.I,
        )

    executable = mask_non_executable(converted)
    create_match = re.search(
        rf"\bCREATE\s+{target_object_type}\s+{re.escape(object_name)}\b",
        executable,
        re.I,
    )
    if not create_match:
        raise ValueError(f"cannot locate converted routine header for {object_name}")
    marker = _routine_marker(executable, create_match.end())
    begin_match = re.search(r"\bBEGIN\b", executable[marker.end() :], re.I)
    if not begin_match:
        raise ValueError(f"cannot locate routine body for {object_name}")
    begin_start = marker.end() + begin_match.start()

    header = converted[: marker.start()]
    declarations = converted[marker.end() : begin_start]
    body = converted[begin_start:]
    collection_result = bool(
        re.search(
            r"\bRETURN\s+(?:TYPE_TB_[A-Z0-9_$#]*|STRSPLIT_TYPE)\b",
            mask_non_executable(source_text),
            re.I,
        )
    )

    if source_object_type == "FUNCTION":
        return_start, return_type = _return_type(header)
        header = header[:return_start].rstrip()
        if target_object_type == "FUNCTION":
            header = _convert_parameter_modes(header, target_object_type)
            data_access = (
                "MODIFIES SQL DATA"
                if re.search(
                    r"\b(?:INSERT\s+INTO|UPDATE\s+\w+|DELETE\s+FROM)\b",
                    mask_non_executable(source_text),
                    re.I,
                )
                else "READS SQL DATA"
            )
            header += f"\nRETURNS {return_type}\nNOT DETERMINISTIC\n{data_access}\n"
        else:
            if not collection_result:
                header = _append_out_result_parameter(header, return_type)
            header = _convert_parameter_modes(header, target_object_type).rstrip() + "\n"
    else:
        header = _convert_parameter_modes(header, target_object_type).rstrip() + "\n"

    converted_declarations = _convert_declarations(declarations)
    body_begin = re.search(r"\bBEGIN\b", body, re.I)
    if not body_begin:
        raise ValueError(f"cannot split routine body for {object_name}")
    body_tail = body[body_begin.end() :]
    if target_object_type == "PROCEDURE":
        body_tail = _rewrite_procedure_returns(
            body_tail,
            scalar_result=source_object_type == "FUNCTION" and not collection_result,
        )
        body = "routine_body: BEGIN" + converted_declarations + body_tail
    else:
        protected, replacements = _protect(body_tail)
        protected = re.sub(
            r"(?im)(^[ \t]*|;[ \t]*|\bTHEN[ \t]+|\bELSE[ \t]+)NULL\s*;",
            r"\1DO 0;",
            protected,
        )
        body = "BEGIN" + converted_declarations + _restore(protected, replacements)
    return header + body


def _wrap_routine(
    converted: str,
    source_object_type: str,
    target_object_type: str,
    object_name: str,
) -> str:
    converted = re.sub(r"(?m)^\s*/\s*$", "", converted).rstrip()
    converted = re.sub(
        rf"\bEND(?:\s+{re.escape(object_name)})?\s*;\s*$",
        "END",
        converted,
        count=1,
        flags=re.I,
    )
    return (
        "DELIMITER $$\n\n"
        f"DROP {target_object_type} IF EXISTS {object_name}$$\n\n"
        f"{converted}$$\n\n"
        "DELIMITER ;\n"
    )


def _legacy_sequence_wrapper() -> str:
    return """DELIMITER $$

DROP FUNCTION IF EXISTS F_SEQ_NEXTVAL_ADMIN$$

CREATE FUNCTION F_SEQ_NEXTVAL_ADMIN(P_TABLENAME VARCHAR(4000))
RETURNS BIGINT
NOT DETERMINISTIC
MODIFIES SQL DATA
BEGIN
    RETURN SEQ_NEXTVAL(UPPER(P_TABLENAME));
END$$

DELIMITER ;
"""


def convert_source(relative_path: str, source_bytes: bytes) -> ConversionResult:
    """Convert one source file and return its text plus conversion metadata."""

    source_text = source_bytes.decode("gb18030").replace("\r\n", "\n").replace("\r", "\n")
    source_object_type, object_name = _routine_metadata(source_text)
    if object_name == "F_SEQ_NEXTVAL_ADMIN":
        return ConversionResult(
            sql=_legacy_sequence_wrapper(),
            source_object_type=source_object_type,
            target_object_type="FUNCTION",
            object_name=object_name,
            warnings=[],
        )
    target_object_type = source_object_type
    warnings: list[str] = []
    if source_object_type == "FUNCTION" and _must_be_procedure(source_text, object_name):
        target_object_type = "PROCEDURE"
        warnings.append(f"{object_name}: function requires procedure semantics")
    converted = convert_fragment(source_text)
    converted = _convert_routine_structure(
        converted,
        source_text=source_text,
        source_object_type=source_object_type,
        target_object_type=target_object_type,
        object_name=object_name,
    )
    sql = _wrap_routine(
        converted,
        source_object_type=source_object_type,
        target_object_type=target_object_type,
        object_name=object_name,
    )
    return ConversionResult(
        sql=sql,
        source_object_type=source_object_type,
        target_object_type=target_object_type,
        object_name=object_name,
        warnings=warnings,
    )


def generate_outputs(repo_root: Path) -> list[ConversionResult]:
    manifest = load_manifest(repo_root)
    results: list[ConversionResult] = []
    for source_name, filenames in manifest.items():
        source_dir = repo_root / "bjts" / source_name
        output_dir = repo_root / "bjts" / SOURCE_TO_OUTPUT[source_name]
        output_dir.mkdir(parents=True, exist_ok=True)
        for filename in filenames:
            source_path = source_dir / filename
            result = convert_source(
                f"{source_name}/{filename}",
                source_path.read_bytes(),
            )
            (output_dir / filename).write_text(result.sql, encoding="utf-8", newline="\n")
            results.append(result)
    return results


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, default=Path.cwd())
    parser.add_argument("--write", action="store_true", help="write converted output files")
    args = parser.parse_args(argv)
    if not args.write:
        parser.error("--write is required")
    results = generate_outputs(args.repo_root.resolve())
    converted_functions = sum(
        result.source_object_type == "FUNCTION" and result.target_object_type == "PROCEDURE"
        for result in results
    )
    print(
        f"generated {len(results)} routines; "
        f"{converted_functions} function(s) require procedure semantics"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
