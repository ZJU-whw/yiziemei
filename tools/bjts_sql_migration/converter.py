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


@dataclass(frozen=True)
class ExceptionHandler:
    condition: str
    body_start: int
    body_end: int


@dataclass(frozen=True)
class ExceptionBlock:
    begin_end: int
    exception_start: int
    block_end_start: int
    handlers: tuple[ExceptionHandler, ...]


@dataclass(frozen=True)
class CursorDefinition:
    name: str
    start: int
    end: int
    parameter_names: tuple[str, ...]
    query: str


@dataclass(frozen=True)
class SqlToken:
    start: int
    end: int
    text: str
    kind: str


ROUTINE_PATTERN = re.compile(
    r"\bCREATE\s+OR\s+REPLACE\s+(PROCEDURE|FUNCTION)\s+([A-Z_$#][\w$#]*)",
    re.I,
)

PROTECTED_PREFIX = "__BJTS_PROTECTED_"
ORACLE_FUNCTION_NAMES = (
    "MONTHS_BETWEEN",
    "ADD_MONTHS",
    "REGEXP_SUBSTR",
    "MEDIAN",
    "TO_NUMBER",
    "TO_CHAR",
    "TO_DATE",
    "NEXT_DAY",
    "NVL2",
    "NVL",
    "DECODE",
    "TRUNC",
)
FUNCTIONS_AS_PROCEDURES = (
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
)

COLLECTION_RESULT_COLUMNS: dict[str, tuple[str, ...]] = {
    "FUNC_GET_XJ_SWJG": ("SWJG_DM",),
    "FUNC_GET_SBHZXX": ("YWZLDM", "YWZLMC", "SBYWDM", "SBYWMC", "NUM", "CQCNT"),
    "FUNC_GET_SBHZXX_QXSWJG": (
        "YWZLDM",
        "YWZLMC",
        "SBYWDM",
        "SBYWMC",
        "NUM",
        "CQCNT",
    ),
    "FUNC_GET_SBHZXX_TEST": (
        "YWZLDM",
        "YWZLMC",
        "SBYWDM",
        "SBYWMC",
        "NUM",
        "CQCNT",
    ),
    "FUNC_GET_SBHZXX_TSSWJG": (
        "YWZLDM",
        "YWZLMC",
        "SBYWDM",
        "SBYWMC",
        "NUM",
        "CQCNT",
    ),
    "FUNC_GET_SBLIST": (
        "SBID",
        "SSSQ",
        "SBRQ",
        "QYHGDM",
        "NSRMC",
        "SBYWBDM",
        "FLGLCD",
        "ZZSBB",
        "ZS_SWJG_MC",
        "TS_SWJG_MC",
        "TSJSFS",
        "SBYWBMC",
        "SBTMSE",
        "YDCNT",
        "YJCNT",
        "CQBZ",
    ),
    "FUNC_GET_SBLIST_SORT": (),
    "FUNC_GET_SBLIST_SORT_QXSWJG": (),
    "FUNC_GET_SBLIST_SORT_TEST": (),
    "FUNC_GET_SBLIST_SORT_TSSWJG": (),
    "FUNC_GET_WJDR_SBLIST": (),
    "FUNC_GET_WJDR_SBLIST_TEST": (),
    "FUNC_SHZS_RWWP": (
        "WPDXSFDM",
        "WPDXMC",
        "NSRSBH",
        "QYFZMC",
        "JDMODE",
        "ERRMSG",
    ),
    "FUNC_SHZS_RWWP_BAK20250609": (),
    "FUNC_SHZS_RWWP_BAK_OLD2025": (),
    "FUNC_STRSPLIT": ("COLUMN_VALUE",),
}

for _collection_name in (
    "FUNC_GET_SBLIST_SORT",
    "FUNC_GET_SBLIST_SORT_QXSWJG",
    "FUNC_GET_SBLIST_SORT_TEST",
    "FUNC_GET_SBLIST_SORT_TSSWJG",
    "FUNC_GET_WJDR_SBLIST",
    "FUNC_GET_WJDR_SBLIST_TEST",
):
    COLLECTION_RESULT_COLUMNS[_collection_name] = COLLECTION_RESULT_COLUMNS[
        "FUNC_GET_SBLIST"
    ]

for _collection_name in (
    "FUNC_SHZS_RWWP_BAK20250609",
    "FUNC_SHZS_RWWP_BAK_OLD2025",
):
    COLLECTION_RESULT_COLUMNS[_collection_name] = COLLECTION_RESULT_COLUMNS[
        "FUNC_SHZS_RWWP"
    ]

DYNAMIC_COLLECTION_PROCEDURES = frozenset(
    {
        "FUNC_GET_SBHZXX",
        "FUNC_GET_SBHZXX_QXSWJG",
        "FUNC_GET_SBHZXX_TEST",
        "FUNC_GET_SBHZXX_TSSWJG",
        "FUNC_GET_SBLIST_SORT",
        "FUNC_GET_SBLIST_SORT_QXSWJG",
        "FUNC_GET_SBLIST_SORT_TEST",
        "FUNC_GET_SBLIST_SORT_TSSWJG",
        "FUNC_GET_WJDR_SBLIST",
        "FUNC_GET_WJDR_SBLIST_TEST",
    }
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


def _escape_mysql_string_backslashes(text: str) -> str:
    """Preserve Oracle literal backslashes under MySQL's default SQL mode."""

    parts: list[str] = []
    for segment in _segments(text):
        if not segment.executable and segment.text.startswith("'"):
            parts.append(segment.text.replace("\\", "\\\\"))
        else:
            parts.append(segment.text)
    return "".join(parts)


def _normalize_mysql_line_comments(text: str) -> str:
    """Make Oracle ``--comment`` markers valid under MySQL lexical rules."""

    parts: list[str] = []
    for segment in _segments(text):
        if (
            not segment.executable
            and segment.text.startswith("--")
            and len(segment.text) > 2
            and not segment.text[2].isspace()
        ):
            parts.append("-- " + segment.text[2:])
        else:
            parts.append(segment.text)
    return "".join(parts)


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
    def convert_tokens(value: str) -> str:
        return token_pattern.sub(
            lambda match: mapping[match.group(0).upper()],
            value,
        )

    # Oracle uses double quotes to delimit literal text inside a date format
    # model (for example YYYY"年"MM"月"DD"日").  MySQL expects those literal
    # characters directly in the STR_TO_DATE/DATE_FORMAT format string.
    parts: list[str] = []
    cursor = 0
    for quoted in re.finditer(r'"((?:""|[^"])*)"', oracle_format):
        parts.append(convert_tokens(oracle_format[cursor : quoted.start()]))
        parts.append(quoted.group(1).replace('""', '"'))
        cursor = quoted.end()
    parts.append(convert_tokens(oracle_format[cursor:]))
    return "".join(parts)


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
    if upper_name == "NEXT_DAY" and len(arguments) == 2:
        return f"ORA_NEXT_DAY({arguments[0]}, {arguments[1]})"
    if upper_name == "REGEXP_SUBSTR" and len(arguments) == 6:
        return f"ORA_REGEXP_SUBSTR({', '.join(arguments)})"
    if upper_name == "MEDIAN" and len(arguments) == 1:
        return f"ORA_MEDIAN(JSON_ARRAYAGG({arguments[0]}))"
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
        if upper_name == "TO_CHAR" and re.fullmatch(r"(?:FM)?0+", oracle_format, re.I):
            width = len(re.sub(r"^FM", "", oracle_format, flags=re.I))
            return f"LPAD(CAST({arguments[0]} AS CHAR), {width}, '0')"
        mysql_format = _sql_literal(_mysql_datetime_format(oracle_format))
        function = "STR_TO_DATE" if upper_name == "TO_DATE" else "DATE_FORMAT"
        return f"{function}({arguments[0]}, {mysql_format})"
    if upper_name == "TRUNC" and arguments:
        if len(arguments) == 2:
            oracle_format = _literal(arguments[1], replacements)
            if oracle_format and oracle_format.upper() in {"YY", "YYYY", "RRRR", "YEAR"}:
                return f"MAKEDATE(YEAR({arguments[0]}), 1)"
            if oracle_format and oracle_format.upper() in {"MM", "MONTH"}:
                return (
                    f"CAST(DATE_FORMAT({arguments[0]}, '%Y-%m-01') AS DATETIME)"
                )
            if oracle_format and oracle_format.upper() in {"DD", "DAY"}:
                return f"DATE({arguments[0]})"
            if oracle_format and oracle_format.upper() in {"Q", "QUARTER"}:
                return (
                    f"DATE_ADD(MAKEDATE(YEAR({arguments[0]}), 1), "
                    f"INTERVAL ((QUARTER({arguments[0]}) - 1) * 3) MONTH)"
                )
            return f"TRUNCATE({arguments[0]}, {arguments[1]})"
        if re.fullmatch(r"[+-]?\d+(?:\.\d+)?", arguments[0].strip()) or re.search(
            r"\b(?:RAND|DBMS_RANDOM)\b",
            arguments[0],
            re.I,
        ):
            return f"TRUNCATE({arguments[0]}, 0)"
        return f"DATE({arguments[0]})"
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


def _rewrite_dbms_random_value(text: str) -> str:
    pattern = re.compile(r"\bDBMS_RANDOM\s*\.\s*VALUE\s*\(", re.I)
    search_from = 0
    while True:
        match = pattern.search(text, search_from)
        if not match:
            return text
        opening = text.find("(", match.start())
        closing = _matching_parenthesis(text, opening)
        if closing is None:
            raise ValueError("DBMS_RANDOM.VALUE has no closing parenthesis")
        arguments = _split_arguments(text[opening + 1 : closing])
        if not arguments or len(arguments) > 2:
            raise ValueError("DBMS_RANDOM.VALUE requires zero or two bounds")
        if len(arguments) == 2:
            replacement = (
                f"(RAND() * (({arguments[1]}) - ({arguments[0]})) "
                f"+ ({arguments[0]}))"
            )
        else:
            replacement = "RAND()"
        text = text[: match.start()] + replacement + text[closing + 1 :]
        search_from = match.start() + len(replacement)


def _rewrite_wm_concat(text: str) -> str:
    pattern = re.compile(r"\bWM_CONCAT\s*\(", re.I)
    search_from = 0
    while True:
        match = pattern.search(text, search_from)
        if not match:
            return text
        opening = text.find("(", match.start())
        closing = _matching_parenthesis(text, opening)
        if closing is None:
            raise ValueError("WM_CONCAT has no closing parenthesis")
        expression = text[opening + 1 : closing].strip()
        replacement = f"GROUP_CONCAT({expression} SEPARATOR ',')"
        text = text[: match.start()] + replacement + text[closing + 1 :]
        search_from = match.start() + len(replacement)


def _rewrite_datetime_literal_markers(
    text: str,
    replacements: dict[str, str],
) -> str:
    marker = re.escape(PROTECTED_PREFIX) + r"\d{6}__"
    pattern = re.compile(rf"\b(DATE|TIMESTAMP)\s*({marker})", re.I)

    def replacement(match: re.Match[str]) -> str:
        literal = replacements.get(match.group(2), "")
        if not literal.startswith("'"):
            return match.group(0)
        target = "DATE" if match.group(1).upper() == "DATE" else "DATETIME(6)"
        return f"CAST({match.group(2)} AS {target})"

    return pattern.sub(replacement, text)


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


def _date_identifiers(source_text: str) -> set[str]:
    executable = mask_non_executable(source_text)
    return {
        match.group(1).upper()
        for match in re.finditer(
            r"\b([A-Z_$#][\w$#]*)\s+"
            r"(?:(?:IN\s+OUT|IN|OUT)\s+)?DATE\b",
            executable,
            re.I,
        )
    }


def _identifier_looks_date(identifier: str, date_names: set[str]) -> bool:
    name = re.sub(r"\s", "", identifier).rsplit(".", 1)[-1].upper()
    if name in date_names:
        return True
    # Cursor lowering appends a three-digit sequence to projected field names,
    # while the source model also uses numbered date columns such as CKRQ_1.
    # Recognize the domain's established date suffixes without treating generic
    # ``*_Q``/``*_Z`` values (for example YF_Q) as dates.
    return bool(
        re.search(r"(?:DATE|RQ|SJ)(?:_\d+)?$", name, re.I)
        or re.search(r"(?:^|_)BGQ_[QZ](?:_\d+)?$", name, re.I)
        or re.search(r"(?:^|_)SSQ[QZ](?:_\d+)?$", name, re.I)
    )


def _expression_looks_date(expression: str, date_names: set[str]) -> bool:
    executable = mask_non_executable(expression).strip()
    while executable.startswith("("):
        closing = _matching_parenthesis(executable, 0)
        if closing != len(executable) - 1:
            break
        expression = expression[1:-1].strip()
        executable = mask_non_executable(expression).strip()
    if re.fullmatch(
        r"[A-Z_$#][\w$#]*(?:\s*\.\s*[A-Z_$#][\w$#]*)?",
        executable,
        re.I,
    ):
        return _identifier_looks_date(executable, date_names)
    if re.fullmatch(r"CURRENT_TIMESTAMP(?:\s*\(\s*\d+\s*\))?", executable, re.I):
        return True

    function = re.match(r"([A-Z_$#][\w$#]*)\s*\(", executable, re.I)
    if not function:
        return False
    opening = executable.find("(", function.start())
    closing = _matching_parenthesis(executable, opening)
    if closing is None or executable[closing + 1 :].strip():
        return False
    name = function.group(1).upper()
    if name in {
        "DATE",
        "DATE_ADD",
        "DATE_SUB",
        "LAST_DAY",
        "MAKEDATE",
        "ORA_DATE_ADD",
        "ORA_NEXT_DAY",
        "STR_TO_DATE",
        "TIMESTAMPADD",
    }:
        return True
    if name == "CAST" and re.search(r"\bAS\s+(?:DATE|DATETIME)\b", executable, re.I):
        return True
    if name in {"COALESCE", "GREATEST", "IFNULL", "LEAST", "MAX", "MIN"}:
        arguments = _split_sql_list(expression[opening + 1 : closing])
        return bool(arguments) and all(
            _expression_looks_date(argument, date_names) for argument in arguments
        )
    return False


def _date_math_right_operand(
    text: str,
    masked: str,
    start: int,
    date_names: set[str],
) -> tuple[str, int, bool] | None:
    whitespace = re.match(r"\s*", masked[start:])
    operand_start = start + (whitespace.end() if whitespace else 0)
    numeric = re.match(r"\d+(?:\.\d+)?", masked[operand_start:])
    if numeric:
        operand_end = operand_start + numeric.end()
        return text[operand_start:operand_end], operand_end, False

    identifier = re.match(
        r"[A-Z_$#][\w$#]*(?:\s*\.\s*[A-Z_$#][\w$#]*)?",
        masked[operand_start:],
        re.I,
    )
    if not identifier:
        return None
    identifier_end = operand_start + identifier.end()
    following = re.match(r"\s*", masked[identifier_end:])
    after_identifier = identifier_end + (following.end() if following else 0)
    if after_identifier < len(masked) and masked[after_identifier] == "(":
        closing = _matching_parenthesis(masked, after_identifier)
        if closing is None:
            return None
        expression = text[operand_start : closing + 1]
        if not _expression_looks_date(expression, date_names):
            return None
        return expression, closing + 1, True
    expression = text[operand_start:identifier_end]
    if expression.upper() == "INTERVAL":
        return None
    return expression, identifier_end, _identifier_looks_date(expression, date_names)


def _date_math_replacement(left: str, operator: str, right: str, right_is_date: bool) -> str | None:
    if operator == "-" and right_is_date:
        return f"ORA_DATE_DIFF({left}, {right})"
    if operator == "+" and right_is_date:
        return None
    days = right if operator == "+" else f"-({right})"
    return f"ORA_DATE_ADD({left}, {days})"


def _rewrite_date_arithmetic(text: str, date_names: set[str]) -> str:
    """Preserve Oracle DATE +/- day and DATE - DATE semantics in MySQL."""

    function_pattern = re.compile(r"\b([A-Z_$#][\w$#]*)\s*\(", re.I)
    identifier_pattern = re.compile(
        r"(?<![\w$#.])([A-Z_$#][\w$#]*(?:\s*\.\s*[A-Z_$#][\w$#]*)?)",
        re.I,
    )
    current_pattern = re.compile(
        r"\bCURRENT_TIMESTAMP(?:\s*\(\s*\d+\s*\))?",
        re.I,
    )

    while True:
        masked = mask_non_executable(text)
        changed = False

        for current in current_pattern.finditer(masked):
            operator = re.match(r"\s*([+-])", masked[current.end() :])
            if not operator:
                continue
            right_start = current.end() + operator.end()
            right = _date_math_right_operand(text, masked, right_start, date_names)
            if not right:
                continue
            right_sql, right_end, right_is_date = right
            replacement = _date_math_replacement(
                text[current.start() : current.end()],
                operator.group(1),
                right_sql,
                right_is_date,
            )
            if replacement is None:
                continue
            text = text[: current.start()] + replacement + text[right_end:]
            changed = True
            break
        if changed:
            continue

        masked = mask_non_executable(text)
        for function in function_pattern.finditer(masked):
            opening = masked.find("(", function.start(), function.end())
            closing = _matching_parenthesis(masked, opening)
            if closing is None:
                continue
            left_sql = text[function.start() : closing + 1]
            if not _expression_looks_date(left_sql, date_names):
                continue
            operator = re.match(r"\s*([+-])", masked[closing + 1 :])
            if not operator:
                continue
            right_start = closing + 1 + operator.end()
            right = _date_math_right_operand(text, masked, right_start, date_names)
            if not right:
                continue
            right_sql, right_end, right_is_date = right
            replacement = _date_math_replacement(
                left_sql,
                operator.group(1),
                right_sql,
                right_is_date,
            )
            if replacement is None:
                continue
            text = text[: function.start()] + replacement + text[right_end:]
            changed = True
            break
        if changed:
            continue

        masked = mask_non_executable(text)
        for identifier in identifier_pattern.finditer(masked):
            left_sql = text[identifier.start() : identifier.end()]
            if not _identifier_looks_date(left_sql, date_names):
                continue
            operator = re.match(r"\s*([+-])", masked[identifier.end() :])
            if not operator:
                continue
            right_start = identifier.end() + operator.end()
            right = _date_math_right_operand(text, masked, right_start, date_names)
            if not right:
                continue
            right_sql, right_end, right_is_date = right
            replacement = _date_math_replacement(
                left_sql,
                operator.group(1),
                right_sql,
                right_is_date,
            )
            if replacement is None:
                continue
            text = text[: identifier.start()] + replacement + text[right_end:]
            changed = True
            break
        if not changed:
            return text


def convert_fragment(text: str) -> str:
    """Convert safe common constructs without touching comments or literals."""

    protected, replacements = _protect(text)
    converted = _rewrite_datetime_literal_markers(protected, replacements)
    converted = _rewrite_function_calls(converted, replacements)
    converted = _rewrite_dbms_random_value(converted)
    converted = _rewrite_wm_concat(converted)
    converted = re.sub(
        r"\bSYS_GUID\s*\(\s*\)",
        "REPLACE(UUID(), '-', '')",
        converted,
        flags=re.I,
    )
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


def _ensure_parameter_list(
    header: str,
    target_object_type: str,
    object_name: str,
) -> str:
    """Add MySQL's required empty parentheses to a no-argument routine."""

    masked = mask_non_executable(header)
    create_match = re.search(
        rf"\bCREATE\s+{target_object_type}\s+{re.escape(object_name)}\b",
        masked,
        re.I,
    )
    if not create_match:
        raise ValueError(f"cannot locate routine name in header for {object_name}")
    if masked[create_match.end() :].lstrip().startswith("("):
        return header
    return header[: create_match.end()] + "()" + header[create_match.end() :]


def _rewrite_procedure_returns(body: str, scalar_result: bool) -> str:
    protected, replacements = _protect(body)
    if scalar_result:
        protected = re.sub(
            r"\bRETURN\s*(?!;)([^;]+);",
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


def _result_projection(arguments: list[str], columns: tuple[str, ...]) -> str:
    values = arguments[: len(columns)]
    values.extend("NULL" for _ in range(len(columns) - len(values)))
    return ",\n       ".join(
        f"{value.strip()} AS {column}"
        for value, column in zip(values, columns)
    )


def _remove_collection_declarations(text: str) -> str:
    protected, replacements = _protect(text)
    protected = re.sub(
        r"(?im)^[ \t]*DECLARE\s+[A-Z_$#][\w$#]*\s+"
        r"(?:TYPE_CURSOR|TYPE_TB_[A-Z0-9_$#]+)\b[^;]*;[ \t]*(?:\n|$)",
        "",
        protected,
    )
    protected = re.sub(
        r"(?im)^[ \t]*-- Oracle REF CURSOR type removed; target uses a result set;?"
        r"[ \t]*(?:\n|$)",
        "",
        protected,
    )
    return _restore(protected, replacements)


def _replace_collection_returns(text: str, columns: tuple[str, ...]) -> str:
    masked = mask_non_executable(text)
    matches = list(re.finditer(r"\bLEAVE\s+routine_body\s*;", masked, re.I))
    if not matches:
        return text
    empty_projection = ", ".join(f"NULL AS {column}" for column in columns)
    for index, match in reversed(list(enumerate(matches))):
        replacement = "" if index == len(matches) - 1 else (
            f"SELECT {empty_projection} WHERE 1 = 0; LEAVE routine_body;"
        )
        text = text[: match.start()] + replacement + text[match.end() :]
    return text


def _rewrite_xj_swjg_table_calls(text: str) -> str:
    pattern = re.compile(
        r"\bSELECT\s+SWJG_DM\s+FROM\s+TABLE\s*\(\s*FUNC_GET_XJ_SWJG\s*\(",
        re.I,
    )
    while True:
        masked = mask_non_executable(text)
        call = pattern.search(masked)
        if not call:
            return text
        function_opening = masked.rfind("(", call.start(), call.end())
        function_closing = _matching_parenthesis(masked, function_opening)
        if function_closing is None:
            raise ValueError("FUNC_GET_XJ_SWJG table call is unbalanced")
        table_closing = re.match(r"\s*\)", masked[function_closing + 1 :])
        if not table_closing:
            raise ValueError("FUNC_GET_XJ_SWJG TABLE wrapper is unbalanced")
        replace_end = function_closing + 1 + table_closing.end()
        argument = text[function_opening + 1 : function_closing].strip()
        replacement = (
            "SELECT VIR_SWJGDM AS SWJG_DM\n"
            "       FROM DM_SWJG_VIRTUAL\n"
            f"      WHERE SUBSTR({argument}, 1, 1) = '2'\n"
            f"        AND SWJG_DM = {argument}\n"
            "        AND YXBZ = 'Y'\n"
            "        AND VIR_FLAG = '0'\n"
            "      UNION ALL\n"
            "     SELECT SWJG_DM AS SWJG_DM\n"
            "       FROM DM_SWJG\n"
            f"      WHERE (SUBSTR({argument}, 1, 1) <> '2' "
            f"OR SUBSTR({argument}, 1, 1) IS NULL)\n"
            f"        AND SWJG_DM_SJ = {argument}\n"
            "        AND TSJG_BZ = '1'"
        )
        text = text[: call.start()] + replacement + text[replace_end:]


def _rewrite_split_table_calls(text: str) -> str:
    pattern = re.compile(
        r"\bSELECT\s+\*\s+FROM\s+TABLE\s*\(\s*FUNC_STRSPLIT\s*\(",
        re.I,
    )
    while True:
        masked = mask_non_executable(text)
        call = pattern.search(masked)
        if not call:
            return text
        function_opening = masked.rfind("(", call.start(), call.end())
        function_closing = _matching_parenthesis(masked, function_opening)
        if function_closing is None:
            raise ValueError("FUNC_STRSPLIT table call is unbalanced")
        table_closing = re.match(r"\s*\)", masked[function_closing + 1 :])
        if not table_closing:
            raise ValueError("FUNC_STRSPLIT TABLE wrapper is unbalanced")
        replace_end = function_closing + 1 + table_closing.end()
        arguments = _split_sql_list(text[function_opening + 1 : function_closing])
        if len(arguments) == 1:
            arguments.append("','")
        if len(arguments) != 2:
            raise ValueError("FUNC_STRSPLIT table call requires one or two arguments")
        replacement = (
            "SELECT BJTS_SPLIT_ITEM.COLUMN_VALUE\n"
            "  FROM JSON_TABLE("
            f"ORA_SPLIT_JSON({arguments[0]}, {arguments[1]}),\n"
            "       '$[*]' COLUMNS (COLUMN_VALUE VARCHAR(4000) PATH '$')\n"
            "  ) AS BJTS_SPLIT_ITEM"
        )
        text = text[: call.start()] + replacement + text[replace_end:]


def _collection_constructor_arguments(
    text: str,
    record_type: str,
) -> tuple[int, int, list[str]]:
    masked = mask_non_executable(text)
    constructor = re.search(rf"\b{re.escape(record_type)}\s*\(", masked, re.I)
    if not constructor:
        raise ValueError(f"collection constructor {record_type} was not found")
    opening = masked.find("(", constructor.start())
    closing = _matching_parenthesis(masked, opening)
    if closing is None:
        raise ValueError(f"collection constructor {record_type} is unbalanced")
    return constructor.start(), closing + 1, _split_sql_list(text[opening + 1 : closing])


def _rewrite_static_collection_result(text: str, object_name: str) -> str:
    columns = COLLECTION_RESULT_COLUMNS[object_name]
    masked = mask_non_executable(text)
    header = re.search(r"\bFOR\s+([A-Z_$#][\w$#]*)\s+IN\s*\(", masked, re.I)
    if not header:
        raise ValueError(f"{object_name} has no collection cursor loop")
    record_name = header.group(1)
    query_opening = masked.find("(", header.start())
    query_closing = _matching_parenthesis(masked, query_opening)
    if query_closing is None:
        raise ValueError(f"{object_name} collection query is unbalanced")
    loop_keyword = re.match(r"\s*LOOP\b", masked[query_closing + 1 :], re.I)
    if not loop_keyword:
        raise ValueError(f"{object_name} collection query has no LOOP")
    loop_start = query_closing + 1 + loop_keyword.start()
    loop_end_start, loop_end = _loop_end(masked, loop_start)
    loop_body = text[query_closing + 1 + loop_keyword.end() : loop_end_start]
    _, _, arguments = _collection_constructor_arguments(
        loop_body,
        "TYPE_REC_SBLIST",
    )
    qualified_arguments = [
        re.sub(
            rf"\b{re.escape(record_name)}\s*\.",
            "BJTS_RESULT_SOURCE.",
            argument,
            flags=re.I,
        )
        for argument in arguments
    ]
    query = text[query_opening + 1 : query_closing].strip()
    replacement = (
        "SELECT "
        + _result_projection(qualified_arguments, columns)
        + "\n  FROM (\n"
        + query
        + "\n  ) AS BJTS_RESULT_SOURCE;"
    )
    text = text[: header.start()] + replacement + text[loop_end:]
    text = _remove_collection_declarations(text)
    return _replace_collection_returns(text, columns)


def _rewrite_dynamic_collection_result(text: str, object_name: str) -> str:
    columns = COLLECTION_RESULT_COLUMNS[object_name]
    text = _rewrite_dynamic_variable_assignments(text, {"DYN_SELECT"})
    masked = mask_non_executable(text)
    opened = re.search(
        r"\bOPEN\s+([A-Z_$#][\w$#]*)\s+FOR\s+dyn_select\s*;",
        masked,
        re.I,
    )
    if not opened:
        raise ValueError(f"{object_name} has no dynamic result cursor")
    cursor_name = opened.group(1)
    loop_keyword = re.match(r"\s*LOOP\b", masked[opened.end() :], re.I)
    if not loop_keyword:
        raise ValueError(f"{object_name} dynamic cursor has no LOOP")
    loop_start = opened.end() + loop_keyword.start()
    loop_end_start, loop_end = _loop_end(masked, loop_start)
    loop_body = text[opened.end() + loop_keyword.end() : loop_end_start]
    fetch = re.search(
        rf"\bFETCH\s+{re.escape(cursor_name)}\s+INTO\s+([^;]+);",
        mask_non_executable(loop_body),
        re.I,
    )
    if not fetch:
        raise ValueError(f"{object_name} dynamic cursor has no FETCH")
    fetch_variables = _split_sql_list(loop_body[fetch.start(1) : fetch.end(1)])
    record_type = "TYPE_REC_SBHZXX" if "SBHZXX" in object_name else "TYPE_REC_SBLIST"
    _, _, arguments = _collection_constructor_arguments(loop_body, record_type)
    arguments = [_rewrite_concatenation(argument) for argument in arguments]
    projection = _result_projection(arguments, columns)
    prefix = "WITH BJTS_RESULT_SOURCE (" + ", ".join(fetch_variables) + ") AS ("
    suffix = ") SELECT " + projection + " FROM BJTS_RESULT_SOURCE"
    close = re.match(
        rf"\s*CLOSE\s+{re.escape(cursor_name)}\s*;",
        masked[loop_end:],
        re.I,
    )
    replace_end = loop_end + (close.end() if close else 0)
    replacement = (
        f"SET dyn_select = CONCAT({_sql_literal(prefix)}, dyn_select, "
        f"{_sql_literal(suffix)});\n"
        "  SET @BJTS_RESULT_SQL_001 = dyn_select;\n"
        "  PREPARE BJTS_RESULT_STMT_001 FROM @BJTS_RESULT_SQL_001;\n"
        "  EXECUTE BJTS_RESULT_STMT_001;\n"
        "  DEALLOCATE PREPARE BJTS_RESULT_STMT_001;"
    )
    text = text[: opened.start()] + replacement + text[replace_end:]
    text = _remove_collection_declarations(text)
    return _replace_collection_returns(text, columns)


def _rewrite_single_row_collection_result(text: str, object_name: str) -> str:
    columns = COLLECTION_RESULT_COLUMNS[object_name]
    constructor_start, constructor_end, arguments = _collection_constructor_arguments(
        text,
        "TYPE_REC_SHZS_RWWP",
    )
    masked = mask_non_executable(text)
    statement_start = masked.rfind("\n", 0, constructor_start) + 1
    extend_matches = list(re.finditer(
        r"[A-Z_$#][\w$#]*\s*\.\s*EXTEND\s*;",
        masked[:constructor_start],
        re.I,
    ))
    if extend_matches:
        extend = extend_matches[-1]
        between = masked[extend.end() : constructor_start]
        if re.fullmatch(
            r"\s*[A-Z_$#][\w$#]*\s*\([^;]+\)\s*:=\s*",
            between,
            re.I,
        ):
            statement_start = extend.start()
    terminator = masked.find(";", constructor_end)
    if terminator < 0:
        raise ValueError(f"{object_name} collection constructor has no terminator")
    replacement = "SELECT " + _result_projection(arguments, columns) + ";"
    text = text[:statement_start] + replacement + text[terminator + 1 :]
    text = _remove_collection_declarations(text)
    return _replace_collection_returns(text, columns)


def _rewrite_collection_result_procedure(text: str, object_name: str) -> str:
    if object_name == "FUNC_GET_SBLIST":
        return _rewrite_static_collection_result(text, object_name)
    if object_name in DYNAMIC_COLLECTION_PROCEDURES:
        return _rewrite_dynamic_collection_result(text, object_name)
    if object_name.startswith("FUNC_SHZS_RWWP"):
        return _rewrite_single_row_collection_result(text, object_name)
    return text


def _rewrite_temp_data_init(text: str) -> str:
    text = _rewrite_dynamic_variable_assignments(text, {"DYN_SELECT"})
    masked = mask_non_executable(text)
    opened = re.search(
        r"\bOPEN\s+([A-Z_$#][\w$#]*)\s+FOR\s+dyn_select\s*;",
        masked,
        re.I,
    )
    if not opened:
        raise ValueError("TEMP_DATA_INIT has no dynamic source cursor")
    cursor_name = opened.group(1)
    loop_keyword = re.match(r"\s*LOOP\b", masked[opened.end() :], re.I)
    if not loop_keyword:
        raise ValueError("TEMP_DATA_INIT dynamic cursor has no LOOP")
    loop_start = opened.end() + loop_keyword.start()
    _, loop_end = _loop_end(masked, loop_start)
    close = re.match(
        rf"\s*CLOSE\s+{re.escape(cursor_name)}\s*;",
        masked[loop_end:],
        re.I,
    )
    replace_end = loop_end + (close.end() if close else 0)
    insert_prefix = (
        "INSERT INTO TB_REPORT_DATA "
        "SELECT BJTS_REPORT_SOURCE.id, BJTS_REPORT_SOURCE.sbqb, "
        "BJTS_REPORT_SOURCE.value, BJTS_REPORT_SOURCE.sbywbDm, "
        "BJTS_REPORT_SOURCE.swjgDm, '0', CURRENT_TIMESTAMP FROM ("
    )
    insert_suffix = ") AS BJTS_REPORT_SOURCE"
    replacement = (
        f"SET dyn_select = CONCAT({_sql_literal(insert_prefix)}, dyn_select, "
        f"{_sql_literal(insert_suffix)});\n"
        "  SET @BJTS_DYNAMIC_SQL_001 = dyn_select;\n"
        "  PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;\n"
        "  EXECUTE BJTS_DYNAMIC_STMT_001;\n"
        "  DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;\n"
        "  COMMIT;"
    )
    text = text[: opened.start()] + replacement + text[replace_end:]
    protected, replacements = _protect(text)
    protected = re.sub(
        r"(?im)^[ \t]*DECLARE\s+[A-Z_$#][\w$#]*\s+TYPE_CURSOR\b[^;]*;"
        r"[ \t]*(?:\n|$)",
        "",
        protected,
    )
    protected = re.sub(
        r"(?im)^[ \t]*DECLARE\s+PRAGMA\s+AUTONOMOUS_TRANSACTION\s*;"
        r"[ \t]*(?:\n|$)",
        "",
        protected,
    )
    return _restore(protected, replacements)


def _exception_blocks(text: str) -> list[ExceptionBlock]:
    """Locate PL/SQL BEGIN/EXCEPTION/END blocks outside comments and strings."""

    masked = mask_non_executable(text)
    token_pattern = re.compile(r"\b(?:BEGIN|END|IF|LOOP|CASE|EXCEPTION)\b", re.I)
    stack: list[dict[str, int | str | None]] = []
    blocks: list[ExceptionBlock] = []
    skipped_control_at: set[int] = set()

    for token in token_pattern.finditer(masked):
        if token.start() in skipped_control_at:
            continue
        keyword = token.group(0).upper()
        if keyword in {"BEGIN", "IF", "LOOP", "CASE"}:
            stack.append(
                {
                    "kind": keyword,
                    "start": token.start(),
                    "end": token.end(),
                    "exception": None,
                }
            )
            continue
        if keyword == "EXCEPTION":
            begin = next(
                (frame for frame in reversed(stack) if frame["kind"] == "BEGIN"),
                None,
            )
            if begin is not None:
                begin["exception"] = token.start()
            continue

        suffix = re.match(r"\s*(IF|LOOP|CASE)\b", masked[token.end() :], re.I)
        expected = suffix.group(1).upper() if suffix else None
        if suffix:
            skipped_control_at.add(token.end() + suffix.start(1))
        if not stack:
            continue
        if expected is None:
            frame = stack.pop()
        else:
            frame = stack.pop()
            if frame["kind"] != expected:
                raise ValueError(
                    f"unbalanced procedural block: END {expected} closes {frame['kind']}"
                )
        exception_start = frame["exception"]
        if frame["kind"] != "BEGIN" or exception_start is None:
            continue
        header = masked[int(exception_start) : token.start()]
        exception_keyword = re.match(r"EXCEPTION\b", header, re.I)
        if not exception_keyword:
            raise ValueError("unsupported Oracle exception handler")
        handler_matches = list(
            re.finditer(
                r"\bWHEN\s+(OTHERS|NO_DATA_FOUND|TOO_MANY_ROWS)\s+THEN\b",
                header[exception_keyword.end() :],
                re.I,
            )
        )
        if not handler_matches:
            excerpt = re.sub(r"\s+", " ", header[:240]).strip()
            raise ValueError(
                "Oracle exception block has no supported handler near: " + excerpt
            )
        prefix = header[
            exception_keyword.end() : exception_keyword.end() + handler_matches[0].start()
        ]
        if prefix.strip():
            raise ValueError("unsupported content before Oracle exception handler")
        handlers: list[ExceptionHandler] = []
        for index, handler in enumerate(handler_matches):
            body_start = (
                int(exception_start)
                + exception_keyword.end()
                + handler.end()
            )
            if index + 1 < len(handler_matches):
                body_end = (
                    int(exception_start)
                    + exception_keyword.end()
                    + handler_matches[index + 1].start()
                )
            else:
                body_end = token.start()
            handlers.append(
                ExceptionHandler(
                    condition=handler.group(1).upper(),
                    body_start=body_start,
                    body_end=body_end,
                )
            )
        blocks.append(
            ExceptionBlock(
                begin_end=int(frame["end"]),
                exception_start=int(exception_start),
                block_end_start=token.start(),
                handlers=tuple(handlers),
            )
        )
    # Nested handlers must be lowered before their enclosing handler.  Otherwise
    # the outer WHEN scan mistakes the inner WHEN clauses for sibling branches.
    return sorted(blocks, key=lambda block: block.exception_start, reverse=True)


def _leading_declarations_end(text: str, begin_end: int, limit: int) -> int:
    """Return the insertion point after declarations at the head of a MySQL block."""

    masked = mask_non_executable(text)
    cursor = begin_end
    while cursor < limit:
        nonspace = re.search(r"\S", masked[cursor:limit])
        if not nonspace:
            return cursor
        declaration_start = cursor + nonspace.start()
        if not re.match(r"DECLARE\b", masked[declaration_start:], re.I):
            return declaration_start
        terminator = masked.find(";", declaration_start, limit)
        if terminator < 0:
            raise ValueError("unterminated MySQL declaration")
        cursor = terminator + 1
    return cursor


def _rewrite_handler_diagnostics(handler_body: str, sequence: int) -> str:
    protected, replacements = _protect(handler_body)
    protected = re.sub(
        r"\bSQLCODE\b",
        f"BJTS_SQLCODE_{sequence:03d}",
        protected,
        flags=re.I,
    )
    protected = re.sub(
        r"\bSQLERRM\b",
        f"BJTS_SQLERRM_{sequence:03d}",
        protected,
        flags=re.I,
    )
    protected = re.sub(r"\bRAISE\s*;", "RESIGNAL;", protected, flags=re.I)
    return _restore(protected, replacements)


def _rewrite_exception_blocks(text: str) -> str:
    sequence = 1
    while True:
        blocks = _exception_blocks(text)
        if not blocks:
            return text
        block = blocks[0]
        declaration_end = _leading_declarations_end(
            text,
            block.begin_end,
            block.exception_start,
        )
        diagnostic_declarations = (
            f"\n  DECLARE BJTS_SQLCODE_{sequence:03d} INT DEFAULT 0;"
            f"\n  DECLARE BJTS_SQLERRM_{sequence:03d} TEXT DEFAULT '';"
        )
        handler_declarations: list[str] = []
        mysql_conditions = {
            "NO_DATA_FOUND": "NOT FOUND",
            "TOO_MANY_ROWS": "1172",
            "OTHERS": "SQLEXCEPTION",
        }
        for handler in block.handlers:
            handler_body = _rewrite_handler_diagnostics(
                text[handler.body_start : handler.body_end],
                sequence,
            )
            handler_declarations.append(
                f"\n  DECLARE EXIT HANDLER FOR {mysql_conditions[handler.condition]}\n"
                "  BEGIN\n"
                f"    GET DIAGNOSTICS CONDITION 1 "
                f"BJTS_SQLCODE_{sequence:03d} = MYSQL_ERRNO, "
                f"BJTS_SQLERRM_{sequence:03d} = MESSAGE_TEXT;"
                f"{handler_body}"
                "\n  END;\n"
            )
        handler_declaration = "".join(handler_declarations)
        text = (
            text[: block.begin_end]
            + diagnostic_declarations
            + text[block.begin_end : declaration_end]
            + handler_declaration
            + text[declaration_end : block.exception_start]
            + text[block.block_end_start :]
        )
        sequence += 1


def _loop_end(masked: str, loop_start: int) -> tuple[int, int]:
    """Return the start and end offsets of the matching END LOOP statement."""

    tokens = re.compile(r"\bEND\s+LOOP\b|\bLOOP\b", re.I)
    depth = 0
    for token in tokens.finditer(masked, loop_start):
        if token.group(0).upper().startswith("END"):
            depth -= 1
            if depth == 0:
                terminator = re.match(r"\s*;", masked[token.end() :])
                end = token.end() + (terminator.end() if terminator else 0)
                return token.start(), end
        else:
            depth += 1
    raise ValueError("loop has no matching END LOOP")


def _top_level_keyword(text: str, keyword: str, start: int = 0) -> re.Match[str] | None:
    masked = mask_non_executable(text)
    depth = 0
    pattern = re.compile(rf"\b{re.escape(keyword)}\b", re.I)
    matches = iter(pattern.finditer(masked, start))
    candidate = next(matches, None)
    for index in range(start, len(masked)):
        char = masked[index]
        if char == "(":
            depth += 1
        elif char == ")":
            depth = max(0, depth - 1)
        while candidate is not None and candidate.start() == index:
            if depth == 0:
                return candidate
            candidate = next(matches, None)
    return None


def _split_sql_list(text: str) -> list[str]:
    masked = mask_non_executable(text)
    parts: list[str] = []
    depth = 0
    start = 0
    for index, char in enumerate(masked):
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
        elif char == "," and depth == 0:
            parts.append(text[start:index].strip())
            start = index + 1
    parts.append(text[start:].strip())
    return parts


def _cursor_select_fields(query: str) -> list[str]:
    masked = mask_non_executable(query)
    select = re.search(r"\bSELECT\b", masked, re.I)
    if not select:
        raise ValueError("implicit cursor query has no SELECT")
    from_match = _top_level_keyword(query, "FROM", select.end())
    if not from_match:
        raise ValueError("implicit cursor query has no top-level FROM")
    select_list = query[select.end() : from_match.start()]
    select_list = re.sub(r"^\s*(?:DISTINCT|ALL)\b", "", select_list, flags=re.I)
    fields: list[str] = []
    for position, item in enumerate(_split_sql_list(select_list), start=1):
        executable = mask_non_executable(item).strip()
        alias = re.search(r"\bAS\s+([A-Z_$#][\w$#]*)\s*$", executable, re.I)
        if alias:
            fields.append(alias.group(1).upper())
            continue
        simple = re.search(
            r"(?:^|\.)([A-Z_$#][\w$#]*)\s*$",
            executable,
            re.I,
        )
        if simple:
            fields.append(simple.group(1).upper())
            continue
        trailing = re.search(r"\s+([A-Z_$#][\w$#]*)\s*$", executable, re.I)
        if trailing:
            fields.append(trailing.group(1).upper())
            continue
        fields.append(f"COLUMN_{position:03d}")
    return fields


def _record_field_references(body: str, record_name: str) -> list[str]:
    executable = mask_non_executable(body)
    return sorted(
        {
            match.group(1).upper()
            for match in re.finditer(
                rf"\b{re.escape(record_name)}\s*\.\s*([A-Z_$#][\w$#]*)",
                executable,
                re.I,
            )
        }
    )


def _expand_cursor_wildcard(
    query: str,
    record_name: str,
    body: str,
) -> str:
    masked = mask_non_executable(query)
    select = re.search(r"\bSELECT\b", masked, re.I)
    if not select:
        return query
    from_match = _top_level_keyword(query, "FROM", select.end())
    if not from_match:
        return query
    select_list = masked[select.end() : from_match.start()].strip()
    wildcard = re.fullmatch(
        r"(?:DISTINCT\s+)?(?:(?P<qualifier>[A-Z_$#][\w$#]*)\s*\.)?\*",
        select_list,
        re.I,
    )
    if not wildcard:
        return query
    references = _record_field_references(body, record_name)
    if not references:
        raise ValueError(f"cannot expand unused wildcard cursor record {record_name}")
    qualifier = wildcard.group("qualifier")
    prefix = f"{qualifier}." if qualifier else ""
    distinct = "DISTINCT " if select_list.upper().startswith("DISTINCT") else ""
    replacement = distinct + ", ".join(prefix + field for field in references)
    return query[: select.end()] + " " + replacement + " " + query[from_match.start() :]


def _safe_generated_identifier(*parts: str) -> str:
    identifier = "_".join(parts).upper()
    identifier = re.sub(r"[^A-Z0-9_$]", "_", identifier)
    if len(identifier) <= 64:
        return identifier
    suffix = identifier[-8:]
    return identifier[:55] + "_" + suffix


def _replace_record_fields(
    body: str,
    record_name: str,
    fields: list[str],
    sequence: int,
) -> tuple[str, list[str]]:
    variables = [
        _safe_generated_identifier(
            "BJTS",
            record_name,
            field,
            f"{sequence:03d}",
        )
        for field in fields
    ]
    mapping = dict(zip((field.upper() for field in fields), variables))
    protected, replacements = _protect(body)
    references = {
        match.group(1).upper()
        for match in re.finditer(
            rf"\b{re.escape(record_name)}\s*\.\s*([A-Z_$#][\w$#]*)",
            protected,
            re.I,
        )
    }
    missing = sorted(references - set(mapping))
    if missing:
        raise ValueError(
            f"cursor record {record_name} references fields absent from SELECT: "
            + ", ".join(missing)
        )
    protected = re.sub(
        rf"\b{re.escape(record_name)}\s*\.\s*([A-Z_$#][\w$#]*)",
        lambda match: mapping[match.group(1).upper()],
        protected,
        flags=re.I,
    )
    return _restore(protected, replacements), variables


def _rewrite_implicit_cursor_loops(text: str) -> str:
    sequence = 1
    header_pattern = re.compile(
        r"\bFOR\s+([A-Z_$#][\w$#]*)\s+IN\s*\(",
        re.I,
    )
    while True:
        masked = mask_non_executable(text)
        matches = list(header_pattern.finditer(masked))
        if not matches:
            return text
        header = matches[-1]
        record_name = header.group(1).upper()
        opening = masked.find("(", header.start())
        closing = _matching_parenthesis(masked, opening)
        if closing is None:
            raise ValueError(f"unclosed implicit cursor query for {record_name}")
        loop_keyword = re.match(r"\s*LOOP\b", masked[closing + 1 :], re.I)
        if not loop_keyword:
            raise ValueError(f"implicit cursor {record_name} has no LOOP")
        loop_start = closing + 1 + loop_keyword.start()
        body_start = closing + 1 + loop_keyword.end()
        loop_end_start, loop_end = _loop_end(masked, loop_start)
        body_text = text[body_start:loop_end_start]
        query = text[opening + 1 : closing].strip()
        query = _expand_cursor_wildcard(query, record_name, body_text)
        fields = _cursor_select_fields(query)
        body, variables = _replace_record_fields(
            body_text,
            record_name,
            fields,
            sequence,
        )
        cursor_name = f"BJTS_CURSOR_{sequence:03d}"
        done_name = f"BJTS_CURSOR_DONE_{sequence:03d}"
        loop_name = f"BJTS_CURSOR_LOOP_{sequence:03d}"
        body = _rewrite_loop_control(body, loop_name)
        variable_declarations = "".join(
            f"\n  DECLARE {variable} LONGTEXT;" for variable in variables
        )
        replacement = (
            "BEGIN"
            f"\n  DECLARE {done_name} BOOLEAN DEFAULT FALSE;"
            f"{variable_declarations}"
            f"\n  DECLARE {cursor_name} CURSOR FOR\n{query};"
            f"\n  OPEN {cursor_name};"
            f"\n  {loop_name}: LOOP"
            f"\n    SET {done_name} = FALSE;"
            "\n    BEGIN"
            f"\n      DECLARE CONTINUE HANDLER FOR NOT FOUND SET {done_name} = TRUE;"
            f"\n      FETCH {cursor_name} INTO {', '.join(variables)};"
            "\n    END;"
            f"\n    IF {done_name} THEN"
            f"\n      LEAVE {loop_name};"
            "\n    END IF;"
            f"{body}"
            f"\n  END LOOP {loop_name};"
            f"\n  CLOSE {cursor_name};"
            "\nEND;"
        )
        text = text[: header.start()] + replacement + text[loop_end:]
        sequence += 1


def _replace_identifier(text: str, source: str, target: str) -> str:
    protected, replacements = _protect(text)
    protected = re.sub(
        rf"\b{re.escape(source)}\b",
        target,
        protected,
        flags=re.I,
    )
    return _restore(protected, replacements)


def _rewrite_numeric_for_loops(text: str) -> str:
    sequence = 1
    pattern = re.compile(
        r"\bFOR\s+([A-Z_$#][\w$#]*)\s+IN\s+"
        r"(REVERSE\s+)?([^;\n]+?)\s*\.\.\s*([^;\n]+?)\s+LOOP\b",
        re.I,
    )
    while True:
        masked = mask_non_executable(text)
        matches = list(pattern.finditer(masked))
        if not matches:
            return text
        header = matches[-1]
        counter = header.group(1).upper()
        reverse = bool(header.group(2))
        lower = text[header.start(3) : header.end(3)].strip()
        upper = text[header.start(4) : header.end(4)].strip()
        loop_end_start, loop_end = _loop_end(masked, header.end() - 4)
        body = text[header.end() : loop_end_start]
        counter_name = f"BJTS_FOR_{counter}_{sequence:03d}"
        end_name = f"BJTS_FOR_END_{sequence:03d}"
        body = _replace_identifier(body, counter, counter_name)
        start_expression = upper if reverse else lower
        end_expression = lower if reverse else upper
        comparator = ">=" if reverse else "<="
        operation = "-" if reverse else "+"
        replacement = (
            "BEGIN"
            f"\n  DECLARE {counter_name} DECIMAL(65,30) DEFAULT {start_expression};"
            f"\n  DECLARE {end_name} DECIMAL(65,30) DEFAULT {end_expression};"
            f"\n  WHILE {counter_name} {comparator} {end_name} DO"
            f"{body}"
            f"\n    SET {counter_name} = {counter_name} {operation} 1;"
            "\n  END WHILE;"
            "\nEND;"
        )
        text = text[: header.start()] + replacement + text[loop_end:]
        sequence += 1


def _declared_cursors(text: str) -> dict[str, CursorDefinition]:
    masked = mask_non_executable(text)
    definitions: dict[str, CursorDefinition] = {}
    pattern = re.compile(r"\bDECLARE\s+([A-Z_$#][\w$#]*)", re.I)
    for declaration in pattern.finditer(masked):
        name = declaration.group(1).upper()
        cursor = declaration.end()
        whitespace = re.match(r"\s*", masked[cursor:])
        cursor += whitespace.end() if whitespace else 0
        parameter_names: tuple[str, ...] = ()
        if cursor < len(masked) and masked[cursor] == "(":
            closing = _matching_parenthesis(masked, cursor)
            if closing is None:
                continue
            parameter_text = text[cursor + 1 : closing]
            names: list[str] = []
            for parameter in _split_sql_list(parameter_text):
                match = re.match(
                    r"\s*([A-Z_$#][\w$#]*)\b",
                    mask_non_executable(parameter),
                    re.I,
                )
                if match:
                    names.append(match.group(1).upper())
            parameter_names = tuple(names)
            cursor = closing + 1
        cursor_for = re.match(r"\s*CURSOR\s+FOR\b", masked[cursor:], re.I)
        if not cursor_for:
            continue
        query_start = cursor + cursor_for.end()
        terminator = masked.find(";", query_start)
        if terminator < 0:
            raise ValueError(f"declared cursor {name} has no terminator")
        definitions[name] = CursorDefinition(
            name=name,
            start=declaration.start(),
            end=terminator + 1,
            parameter_names=parameter_names,
            query=text[query_start:terminator].strip(),
        )
    return definitions


def _cursor_loop_sql(
    query: str,
    record_name: str,
    body: str,
    sequence: int,
    cursor_prefix: str,
) -> str:
    query = _expand_cursor_wildcard(query, record_name, body)
    fields = _cursor_select_fields(query)
    body, variables = _replace_record_fields(
        body,
        record_name,
        fields,
        sequence,
    )
    cursor_name = f"BJTS_{cursor_prefix}_{sequence:03d}"
    done_name = f"BJTS_{cursor_prefix}_DONE_{sequence:03d}"
    loop_name = f"BJTS_{cursor_prefix}_LOOP_{sequence:03d}"
    body = _rewrite_loop_control(body, loop_name)
    variable_declarations = "".join(
        f"\n  DECLARE {variable} LONGTEXT;" for variable in variables
    )
    return (
        "BEGIN"
        f"\n  DECLARE {done_name} BOOLEAN DEFAULT FALSE;"
        f"{variable_declarations}"
        f"\n  DECLARE {cursor_name} CURSOR FOR\n{query};"
        f"\n  OPEN {cursor_name};"
        f"\n  {loop_name}: LOOP"
        f"\n    SET {done_name} = FALSE;"
        "\n    BEGIN"
        f"\n      DECLARE CONTINUE HANDLER FOR NOT FOUND SET {done_name} = TRUE;"
        f"\n      FETCH {cursor_name} INTO {', '.join(variables)};"
        "\n    END;"
        f"\n    IF {done_name} THEN"
        f"\n      LEAVE {loop_name};"
        "\n    END IF;"
        f"{body}"
        f"\n  END LOOP {loop_name};"
        f"\n  CLOSE {cursor_name};"
        "\nEND;"
    )


def _rewrite_named_cursor_loops(text: str) -> str:
    definitions = _declared_cursors(text)
    if not definitions:
        return text
    executable = mask_non_executable(text)
    used_names = {
        match.group(1).upper()
        for match in re.finditer(
            r"\bFOR\s+[A-Z_$#][\w$#]*\s+IN\s+([A-Z_$#][\w$#]*)",
            executable,
            re.I,
        )
        if match.group(1).upper() in definitions
    }
    for definition in sorted(
        (definitions[name] for name in used_names),
        key=lambda value: value.start,
        reverse=True,
    ):
        text = text[: definition.start] + text[definition.end :]

    sequence = 1
    if not used_names:
        return text
    names = "|".join(re.escape(name) for name in sorted(used_names, key=len, reverse=True))
    pattern = re.compile(
        rf"\bFOR\s+([A-Z_$#][\w$#]*)\s+IN\s+({names})\b",
        re.I,
    )
    while True:
        masked = mask_non_executable(text)
        matches = list(pattern.finditer(masked))
        if not matches:
            return text
        header = matches[-1]
        record_name = header.group(1).upper()
        cursor_name = header.group(2).upper()
        definition = definitions[cursor_name]
        cursor = header.end()
        whitespace = re.match(r"\s*", masked[cursor:])
        cursor += whitespace.end() if whitespace else 0
        arguments: list[str] = []
        if cursor < len(masked) and masked[cursor] == "(":
            closing = _matching_parenthesis(masked, cursor)
            if closing is None:
                raise ValueError(f"unclosed cursor arguments for {cursor_name}")
            arguments = _split_sql_list(text[cursor + 1 : closing])
            cursor = closing + 1
        loop_keyword = re.match(r"\s*LOOP\b", masked[cursor:], re.I)
        if not loop_keyword:
            raise ValueError(f"named cursor {cursor_name} has no LOOP")
        if len(arguments) != len(definition.parameter_names):
            raise ValueError(
                f"named cursor {cursor_name} expects {len(definition.parameter_names)} "
                f"arguments, got {len(arguments)}"
            )
        query = definition.query
        for parameter_name, argument in zip(definition.parameter_names, arguments):
            query = _replace_identifier(query, parameter_name, f"({argument.strip()})")
        loop_start = cursor + loop_keyword.start()
        body_start = cursor + loop_keyword.end()
        loop_end_start, loop_end = _loop_end(masked, loop_start)
        replacement = _cursor_loop_sql(
            query,
            record_name,
            text[body_start:loop_end_start],
            sequence,
            "NAMED_CURSOR",
        )
        text = text[: header.start()] + replacement + text[loop_end:]
        sequence += 1


def _rewrite_while_loops(text: str) -> str:
    pattern = re.compile(r"\bWHILE\s+([^;]+?)\s+LOOP\b", re.I | re.S)
    sequence = 1
    while True:
        masked = mask_non_executable(text)
        matches = list(pattern.finditer(masked))
        if not matches:
            return text
        header = matches[-1]
        condition = text[header.start(1) : header.end(1)].strip()
        loop_end_start, loop_end = _loop_end(masked, header.end() - 4)
        body = text[header.end() : loop_end_start]
        label = f"BJTS_WHILE_{sequence:03d}"
        body = _rewrite_loop_control(body, label)
        replacement = (
            f"{label}: WHILE {condition} DO{body}\nEND WHILE {label};"
        )
        text = text[: header.start()] + replacement + text[loop_end:]
        sequence += 1


def _blank_preserving_newlines(text: str) -> str:
    return "".join("\n" if char == "\n" else " " for char in text)


def _rewrite_loop_control(body: str, loop_name: str) -> str:
    protected, replacements = _protect(body)
    protected = re.sub(
        r"\bCONTINUE\s*;",
        f"ITERATE {loop_name};",
        protected,
        flags=re.I,
    )
    protected = re.sub(
        r"\bEXIT\s*;",
        f"LEAVE {loop_name};",
        protected,
        flags=re.I,
    )
    return _restore(protected, replacements)


def _rewrite_plain_loops(text: str) -> str:
    """Label remaining Oracle LOOP blocks and lower EXIT statements to LEAVE."""

    sequence = 1
    while True:
        masked = mask_non_executable(text)
        candidates: list[re.Match[str]] = []
        for loop in re.finditer(r"\bLOOP\b", masked, re.I):
            prefix = masked[max(0, loop.start() - 16) : loop.start()]
            if re.search(r"\bEND\s*$", prefix, re.I):
                continue
            line_start = masked.rfind("\n", 0, loop.start()) + 1
            line_prefix = masked[line_start : loop.start()]
            if re.search(r":\s*$", line_prefix):
                continue
            if re.search(r"\b(?:FOR|WHILE)\b", line_prefix, re.I):
                continue
            candidates.append(loop)
        if not candidates:
            return text

        opening = candidates[-1]
        end_start, end = _loop_end(masked, opening.start())
        label = f"BJTS_LOOP_{sequence:03d}"
        body = text[opening.end() : end_start]
        protected, replacements = _protect(body)
        protected = re.sub(
            r"\bEXIT\s+WHEN\s*([^;]+);",
            rf"IF \1 THEN LEAVE {label}; END IF;",
            protected,
            flags=re.I,
        )
        protected = re.sub(
            r"\bEXIT\s*;",
            f"LEAVE {label};",
            protected,
            flags=re.I,
        )
        body = _restore(protected, replacements)
        end_statement = text[end_start:end]
        end_statement = re.sub(
            r"\bEND\s+LOOP\s*;",
            f"END LOOP {label};",
            end_statement,
            count=1,
            flags=re.I,
        )
        text = (
            text[: opening.start()]
            + f"{label}: LOOP"
            + body
            + end_statement
            + text[end:]
        )
        sequence += 1


def _rowtype_records(text: str) -> dict[str, tuple[str, int, int]]:
    masked = mask_non_executable(text)
    result: dict[str, tuple[str, int, int]] = {}
    pattern = re.compile(
        r"\bDECLARE\s+([A-Z_$#][\w$#]*)\s+"
        r"([A-Z_$#][\w$#]*)\s*%\s*ROWTYPE\s*;",
        re.I,
    )
    for match in pattern.finditer(masked):
        result[match.group(2).upper()] = (
            match.group(1).upper(),
            match.start(),
            match.end(),
        )
    return result


def _bind_cursor_query(
    definition: CursorDefinition,
    arguments: list[str],
) -> str:
    if len(arguments) != len(definition.parameter_names):
        raise ValueError(
            f"cursor {definition.name} expects {len(definition.parameter_names)} "
            f"arguments, got {len(arguments)}"
        )
    query = definition.query
    for parameter_name, argument in zip(definition.parameter_names, arguments):
        query = _replace_identifier(query, parameter_name, f"({argument.strip()})")
    return query


def _rewrite_open_fetch_loops(text: str) -> str:
    definitions = _declared_cursors(text)
    if not definitions:
        return text
    masked = mask_non_executable(text)
    cursor_names = "|".join(
        re.escape(name) for name in sorted(definitions, key=len, reverse=True)
    )
    open_pattern = re.compile(rf"\bOPEN\s+({cursor_names})\b", re.I)
    used_names: set[str] = set()
    for opened in open_pattern.finditer(masked):
        tail = masked[opened.end() :]
        if re.match(r"\s+FOR\b", tail, re.I):
            continue
        used_names.add(opened.group(1).upper())
    if not used_names:
        return text

    rowtypes = _rowtype_records(text)
    blank_ranges = [
        (definitions[name].start, definitions[name].end) for name in used_names
    ]
    blank_ranges.extend(
        (start, end)
        for name, (_, start, end) in rowtypes.items()
        if name in used_names
    )
    for start, end in sorted(blank_ranges, reverse=True):
        text = text[:start] + _blank_preserving_newlines(text[start:end]) + text[end:]

    sequence = 1
    names = "|".join(re.escape(name) for name in sorted(used_names, key=len, reverse=True))
    open_pattern = re.compile(rf"\bOPEN\s+({names})\b", re.I)
    while True:
        masked = mask_non_executable(text)
        candidates = [
            match
            for match in open_pattern.finditer(masked)
            if not re.match(r"\s+FOR\b", masked[match.end() :], re.I)
        ]
        if not candidates:
            return text
        opened = candidates[-1]
        source_cursor = opened.group(1).upper()
        definition = definitions[source_cursor]
        cursor = opened.end()
        whitespace = re.match(r"\s*", masked[cursor:])
        cursor += whitespace.end() if whitespace else 0
        arguments: list[str] = []
        if cursor < len(masked) and masked[cursor] == "(":
            closing = _matching_parenthesis(masked, cursor)
            if closing is None:
                raise ValueError(f"unclosed OPEN arguments for {source_cursor}")
            arguments = _split_sql_list(text[cursor + 1 : closing])
            cursor = closing + 1
        terminator = re.match(r"\s*;", masked[cursor:])
        if not terminator:
            raise ValueError(f"OPEN {source_cursor} has no terminator")
        cursor += terminator.end()
        loop_keyword = re.match(r"\s*LOOP\b", masked[cursor:], re.I)
        if not loop_keyword:
            raise ValueError(f"OPEN {source_cursor} is not followed by LOOP")
        loop_start = cursor + loop_keyword.start()
        body_start = cursor + loop_keyword.end()
        loop_end_start, loop_end = _loop_end(masked, loop_start)
        body = text[body_start:loop_end_start]
        body_masked = mask_non_executable(body)
        fetch = re.search(
            rf"\bFETCH\s+{re.escape(source_cursor)}\s+INTO\s+([^;]+);",
            body_masked,
            re.I,
        )
        if not fetch:
            raise ValueError(f"cursor loop {source_cursor} has no FETCH")
        exit_when = re.search(
            rf"\bEXIT\s+WHEN\s+{re.escape(source_cursor)}\s*%\s*NOTFOUND\s*;",
            body_masked[fetch.end() :],
            re.I,
        )
        if not exit_when:
            raise ValueError(f"cursor loop {source_cursor} has no EXIT WHEN NOTFOUND")
        exit_start = fetch.end() + exit_when.start()
        exit_end = fetch.end() + exit_when.end()
        targets = _split_sql_list(body[fetch.start(1) : fetch.end(1)])
        query = _bind_cursor_query(definition, arguments)
        variable_declarations = ""
        record = rowtypes.get(source_cursor)
        loop_body = body[: fetch.start()] + "__BJTS_FETCH_POINT__"
        loop_body += body[fetch.end() : exit_start]
        loop_body += body[exit_end:]
        if len(targets) == 1 and record and targets[0].strip().upper() == record[0]:
            record_name = record[0]
            query = _expand_cursor_wildcard(query, record_name, loop_body)
            fields = _cursor_select_fields(query)
            loop_body, fetch_variables = _replace_record_fields(
                loop_body,
                record_name,
                fields,
                sequence,
            )
            variable_declarations = "".join(
                f"\n  DECLARE {variable} LONGTEXT;" for variable in fetch_variables
            )
        else:
            fetch_variables = [target.strip() for target in targets]
        generated_cursor = f"BJTS_FETCH_CURSOR_{sequence:03d}"
        done_name = f"BJTS_FETCH_DONE_{sequence:03d}"
        loop_name = f"BJTS_FETCH_LOOP_{sequence:03d}"
        fetch_sql = (
            "BEGIN\n"
            f"      DECLARE CONTINUE HANDLER FOR NOT FOUND SET {done_name} = TRUE;\n"
            f"      FETCH {generated_cursor} INTO {', '.join(fetch_variables)};\n"
            "    END;\n"
            f"    IF {done_name} THEN\n"
            f"      LEAVE {loop_name};\n"
            "    END IF;"
        )
        loop_body = loop_body.replace("__BJTS_FETCH_POINT__", fetch_sql)
        loop_body = _rewrite_loop_control(loop_body, loop_name)
        close = re.match(
            rf"\s*CLOSE\s+{re.escape(source_cursor)}\s*;",
            masked[loop_end:],
            re.I,
        )
        replace_end = loop_end + (close.end() if close else 0)
        replacement = (
            "BEGIN"
            f"\n  DECLARE {done_name} BOOLEAN DEFAULT FALSE;"
            f"{variable_declarations}"
            f"\n  DECLARE {generated_cursor} CURSOR FOR\n{query};"
            f"\n  OPEN {generated_cursor};"
            f"\n  {loop_name}: LOOP"
            f"{loop_body}"
            f"\n  END LOOP {loop_name};"
            f"\n  CLOSE {generated_cursor};"
            "\nEND;"
        )
        text = text[: opened.start()] + replacement + text[replace_end:]
        sequence += 1


def _rewrite_function_procedure_assignments(text: str) -> str:
    """Turn scalar use of a converted function into a procedure OUT call."""

    protected, replacements = _protect(text)
    function_names = "|".join(
        re.escape(name) for name in sorted(FUNCTIONS_AS_PROCEDURES, key=len, reverse=True)
    )
    pattern = re.compile(
        rf"\bSET\s+(?P<target>[@A-Z_$#][\w$#@.]*)\s*=\s*"
        rf"(?P<name>{function_names})\s*\(",
        re.I,
    )
    search_from = 0
    while True:
        call = pattern.search(protected, search_from)
        if not call:
            break
        opening = protected.find("(", call.start(), call.end())
        closing = _matching_parenthesis(protected, opening)
        if closing is None:
            raise ValueError("converted function call has no closing parenthesis")
        terminator = re.match(r"\s*;", protected[closing + 1 :])
        if not terminator:
            search_from = call.end()
            continue
        arguments = protected[opening + 1 : closing].strip()
        if arguments:
            arguments += ", "
        replacement = (
            f"CALL {call.group('name')}({arguments}{call.group('target')});"
        )
        replace_end = closing + 1 + terminator.end()
        protected = protected[: call.start()] + replacement + protected[replace_end:]
        search_from = call.start() + len(replacement)
    return _restore(protected, replacements)


def _rewrite_procedure_calls(text: str) -> str:
    protected, replacements = _protect(text)
    function_names = "|".join(
        re.escape(name) for name in sorted(FUNCTIONS_AS_PROCEDURES, key=len, reverse=True)
    )
    callable_name = (
        rf"(?:PRO_[A-Z0-9_$#]+|PROC_[A-Z0-9_$#]+|P_[A-Z0-9_$#]+|"
        rf"TEMP_[A-Z0-9_$#]+|TMP_[A-Z0-9_$#]+|ORIGINAL_[A-Z0-9_$#]+|"
        rf"{function_names})"
    )
    pattern = re.compile(
        rf"(?im)(^[ \t]*|;[ \t]*|\bTHEN[ \t]+|\bELSE[ \t]+)"
        rf"(?P<name>{callable_name})\s*(?=\()",
        re.I,
    )
    protected = pattern.sub(
        lambda match: f"{match.group(1)}CALL {match.group('name')}",
        protected,
    )
    no_argument_pattern = re.compile(
        rf"(?im)(^[ \t]*|;[ \t]*|\bTHEN[ \t]+|\bELSE[ \t]+)"
        rf"(?P<name>{callable_name})\s*;",
        re.I,
    )
    protected = no_argument_pattern.sub(
        lambda match: f"{match.group(1)}CALL {match.group('name')}();",
        protected,
    )
    return _restore(protected, replacements)


def _sql_tokens(
    protected: str,
    replacements: dict[str, str],
) -> list[SqlToken]:
    marker = re.escape(PROTECTED_PREFIX) + r"\d{6}__"
    pattern = re.compile(
        rf"{marker}|\|\||[A-Z_$#][\w$#]*|\d+(?:\.\d+)?|[^\s]",
        re.I,
    )
    tokens: list[SqlToken] = []
    for match in pattern.finditer(protected):
        value = match.group(0)
        if value in replacements:
            original = replacements[value]
            kind = "string" if original.startswith("'") else "comment"
        elif value == "||":
            kind = "concat"
        elif re.fullmatch(r"[A-Z_$#][\w$#]*", value, re.I):
            kind = "word"
        elif re.fullmatch(r"\d+(?:\.\d+)?", value):
            kind = "number"
        else:
            kind = "symbol"
        tokens.append(SqlToken(match.start(), match.end(), value, kind))
    return tokens


def _previous_code_token(tokens: list[SqlToken], index: int) -> int | None:
    index -= 1
    while index >= 0 and tokens[index].kind == "comment":
        index -= 1
    return index if index >= 0 else None


def _next_code_token(tokens: list[SqlToken], index: int) -> int | None:
    index += 1
    while index < len(tokens) and tokens[index].kind == "comment":
        index += 1
    return index if index < len(tokens) else None


def _matching_token_parenthesis(
    tokens: list[SqlToken],
    opening_index: int,
) -> int:
    depth = 0
    for index in range(opening_index, len(tokens)):
        if tokens[index].text == "(":
            depth += 1
        elif tokens[index].text == ")":
            depth -= 1
            if depth == 0:
                return index
    raise ValueError("unbalanced parenthesis beside Oracle concatenation")


def _matching_token_parenthesis_backwards(
    tokens: list[SqlToken],
    closing_index: int,
) -> int:
    depth = 0
    for index in range(closing_index, -1, -1):
        if tokens[index].text == ")":
            depth += 1
        elif tokens[index].text == "(":
            depth -= 1
            if depth == 0:
                return index
    raise ValueError("unbalanced parenthesis beside Oracle concatenation")


def _case_start_backwards(tokens: list[SqlToken], end_index: int) -> int:
    depth = 0
    for index in range(end_index, -1, -1):
        value = tokens[index].text.upper()
        if value == "END":
            depth += 1
        elif value == "CASE":
            depth -= 1
            if depth == 0:
                return index
    raise ValueError("CASE expression beside concatenation has no start")


def _case_end(tokens: list[SqlToken], case_index: int) -> int:
    depth = 0
    for index in range(case_index, len(tokens)):
        value = tokens[index].text.upper()
        if value == "CASE":
            depth += 1
        elif value == "END":
            depth -= 1
            if depth == 0:
                return index
    raise ValueError("CASE expression beside concatenation has no end")


def _left_concat_operand(tokens: list[SqlToken], operator_index: int) -> int:
    index = _previous_code_token(tokens, operator_index)
    if index is None:
        raise ValueError("Oracle concatenation has no left operand")
    token = tokens[index]
    if token.text == ")":
        opening = _matching_token_parenthesis_backwards(tokens, index)
        callable_index = _previous_code_token(tokens, opening)
        if (
            callable_index is not None
            and tokens[callable_index].text.upper() == "OVER"
        ):
            function_closing = _previous_code_token(tokens, callable_index)
            if function_closing is None or tokens[function_closing].text != ")":
                raise ValueError("OVER clause beside concatenation has no function")
            function_opening = _matching_token_parenthesis_backwards(
                tokens,
                function_closing,
            )
            callable_index = _previous_code_token(tokens, function_opening)
            if callable_index is None:
                raise ValueError("window function beside concatenation has no name")
        if callable_index is not None and tokens[callable_index].kind == "word":
            index = callable_index
            while True:
                dot = _previous_code_token(tokens, index)
                qualifier = _previous_code_token(tokens, dot) if dot is not None else None
                if (
                    dot is not None
                    and qualifier is not None
                    and tokens[dot].text == "."
                    and tokens[qualifier].kind == "word"
                ):
                    index = qualifier
                    continue
                break
            return index
        return opening
    if token.kind == "word" and token.text.upper() == "END":
        return _case_start_backwards(tokens, index)
    if token.kind not in {"word", "number", "string"}:
        raise ValueError(f"unsupported left concatenation operand: {token.text}")
    over_index = _previous_code_token(tokens, index)
    if over_index is not None and tokens[over_index].text.upper() == "OVER":
        function_closing = _previous_code_token(tokens, over_index)
        if function_closing is None or tokens[function_closing].text != ")":
            raise ValueError("named OVER clause beside concatenation has no function")
        function_opening = _matching_token_parenthesis_backwards(tokens, function_closing)
        callable_index = _previous_code_token(tokens, function_opening)
        if callable_index is None:
            raise ValueError("window function beside concatenation has no name")
        index = callable_index
    while True:
        dot = _previous_code_token(tokens, index)
        qualifier = _previous_code_token(tokens, dot) if dot is not None else None
        if (
            dot is not None
            and qualifier is not None
            and tokens[dot].text == "."
            and tokens[qualifier].kind == "word"
        ):
            index = qualifier
            continue
        break
    return index


def _right_concat_operand(tokens: list[SqlToken], operator_index: int) -> int:
    index = _next_code_token(tokens, operator_index)
    if index is None:
        raise ValueError("Oracle concatenation has no right operand")
    if tokens[index].text in {"+", "-"}:
        following = _next_code_token(tokens, index)
        if following is None:
            raise ValueError("unary concatenation operand has no value")
        index = following
    token = tokens[index]
    if token.text == "(":
        return _matching_token_parenthesis(tokens, index)
    if token.kind == "word" and token.text.upper() == "CASE":
        return _case_end(tokens, index)
    if token.kind not in {"word", "number", "string"}:
        raise ValueError(f"unsupported right concatenation operand: {token.text}")
    end = index
    while True:
        dot = _next_code_token(tokens, end)
        field = _next_code_token(tokens, dot) if dot is not None else None
        if (
            dot is not None
            and field is not None
            and tokens[dot].text == "."
            and tokens[field].kind == "word"
        ):
            end = field
            continue
        break
    opening = _next_code_token(tokens, end)
    if opening is not None and tokens[opening].text == "(":
        closing = _matching_token_parenthesis(tokens, opening)
        over_index = _next_code_token(tokens, closing)
        if over_index is not None and tokens[over_index].text.upper() == "OVER":
            window = _next_code_token(tokens, over_index)
            if window is None:
                raise ValueError("window function beside concatenation has no window")
            if tokens[window].text == "(":
                return _matching_token_parenthesis(tokens, window)
            if tokens[window].kind == "word":
                return window
            raise ValueError("unsupported OVER clause beside concatenation")
        return closing
    return end


def _rewrite_concatenation(text: str) -> str:
    protected, replacements = _protect(text)
    while "||" in protected:
        tokens = _sql_tokens(protected, replacements)
        operator_index = next(
            (index for index, token in enumerate(tokens) if token.kind == "concat"),
            None,
        )
        if operator_index is None:
            break
        left_index = _left_concat_operand(tokens, operator_index)
        right_index = _right_concat_operand(tokens, operator_index)
        left_start = tokens[left_index].start
        operator = tokens[operator_index]
        right_end = tokens[right_index].end
        left_sql = protected[left_start : operator.start].strip()
        right_sql = protected[operator.end : right_end].strip()
        replacement = f"ORA_CONCAT({left_sql}, {right_sql})"
        protected = protected[:left_start] + replacement + protected[right_end:]
    return _restore(protected, replacements)


def _rewrite_dynamic_bind_markers(sql: str) -> str:
    protected, replacements = _protect(sql)
    protected = re.sub(r":\d+\b", "?", protected)
    return _restore(protected, replacements)


def _convert_dynamic_literal(literal: str) -> str:
    if not (literal.startswith("'") and literal.endswith("'")):
        return literal
    inner = literal[1:-1].replace("''", "'")
    prefix = ""
    suffix = ""
    core = inner
    if inner.count("'") % 2 == 1:
        first_quote = inner.find("'")
        last_quote = inner.rfind("'")
        if first_quote >= 0 and not inner[:first_quote].strip():
            prefix = inner[: first_quote + 1]
            core = inner[first_quote + 1 :]
        elif last_quote >= 0 and not inner[last_quote + 1 :].strip():
            core = inner[:last_quote]
            suffix = inner[last_quote:]
    core = convert_fragment(core)
    core = _rewrite_date_arithmetic(core, set())
    if re.fullmatch(
        r"\s*SELECT\s+COUNT\s*\(\s*1\s*\)\s+FROM\s+USER_TABLES\s+"
        r"WHERE\s+TABLE_NAME\s*=\s*'TMP_STDDEV'\s*",
        core,
        re.I,
    ):
        # F_MY_STDAVG_TMPTB only uses this probe to decide whether it should
        # execute a defensive drop.  MySQL's metadata tables do not expose
        # session temporary tables reliably, so always take the safe branch.
        core = "SELECT 1"
    core = re.sub(
        r"\bCREATE\s+GLOBAL\s+TEMPORARY\s+TABLE\b",
        "CREATE TEMPORARY TABLE",
        core,
        flags=re.I,
    )
    core = re.sub(
        r"\s+ON\s+COMMIT\s+(?:DELETE|PRESERVE)\s+ROWS\b",
        "",
        core,
        flags=re.I,
    )
    core = re.sub(
        r"\bDROP\s+TABLE\s+TMP_STDDEV\b",
        "DROP TEMPORARY TABLE IF EXISTS TMP_STDDEV",
        core,
        flags=re.I,
    )
    # A date literal can be split across concatenated PL/SQL string fragments,
    # for example ``'... DATE''' || value || ''' AND DATE'''``.  At this point
    # the embedded quote is part of the decoded payload, so remove Oracle's DATE
    # introducer wherever it directly precedes that quote.
    core = re.sub(r"\bDATE(?=\s*')", "", core, flags=re.I)
    if suffix and re.search(r"\bDATE\s*$", core, re.I):
        core = re.sub(r"\bDATE\s*$", "", core, flags=re.I)
    core = re.sub(r"\bNVL\s*\(", "IFNULL(", core, flags=re.I)
    rownum_one = re.search(r"\bROWNUM\s*=\s*1\b", core, re.I)
    if rownum_one:
        at_end = not core[rownum_one.end() :].strip()
        core = core[: rownum_one.start()] + "1=1" + core[rownum_one.end() :]
        if at_end:
            core = core.rstrip() + " LIMIT 1"
    core = _rewrite_concatenation(core)
    inner = prefix + core + suffix
    inner = _rewrite_dynamic_bind_markers(inner)
    return _sql_literal(inner)


def _convert_dynamic_expression(expression: str) -> str:
    parts: list[str] = []
    for segment in _segments(expression):
        if not segment.executable and segment.text.startswith("'"):
            parts.append(_convert_dynamic_literal(segment.text))
        else:
            parts.append(segment.text)
    return "".join(parts)


def _dynamic_sql_variables(text: str) -> set[str]:
    masked = mask_non_executable(text)
    variables: set[str] = set()
    # Some routines return an SQL drill-down payload to the application instead
    # of executing it locally.  The ``[s]select`` marker is the contract used by
    # those callers, so its SQL fragments need the same dialect conversion as
    # EXECUTE IMMEDIATE inputs.
    for assignment in re.finditer(
        r"\bSET\s+([A-Z_$#][\w$#]*)\s*=",
        masked,
        re.I,
    ):
        terminator = masked.find(";", assignment.end())
        if terminator < 0:
            continue
        expression = text[assignment.end() : terminator]
        if re.search(r"'\s*\[s\]\s*select\b", expression, re.I):
            variables.add(assignment.group(1).upper())
    for statement in re.finditer(r"\bEXECUTE\s+IMMEDIATE\b", masked, re.I):
        terminator = masked.find(";", statement.end())
        if terminator < 0:
            continue
        expression = masked[statement.end() : terminator]
        clause = re.search(r"\b(?:INTO|USING)\b", expression, re.I)
        if clause:
            expression = expression[: clause.start()]
        identifier = re.match(r"\s*([A-Z_$#][\w$#]*)\b", expression, re.I)
        if identifier:
            variables.add(identifier.group(1).upper())
    for consumer in re.finditer(r"\bF_MY_STDAVG_TMPTB\s*\(", masked, re.I):
        opening = masked.find("(", consumer.start(), consumer.end())
        closing = _matching_parenthesis(masked, opening)
        if closing is None:
            continue
        first_argument = re.match(
            r"\s*([A-Z_$#][\w$#]*)\b",
            masked[opening + 1 : closing],
            re.I,
        )
        if first_argument:
            variables.add(first_argument.group(1).upper())
    return variables


def _rewrite_dynamic_variable_assignments(text: str, variables: set[str]) -> str:
    if not variables:
        return text
    names = "|".join(re.escape(name) for name in sorted(variables, key=len, reverse=True))
    pattern = re.compile(rf"\bSET\s+(?:{names})\s*=", re.I)
    search_from = 0
    while True:
        masked = mask_non_executable(text)
        assignment = pattern.search(masked, search_from)
        if not assignment:
            break
        terminator = masked.find(";", assignment.end())
        if terminator < 0:
            raise ValueError("dynamic SQL variable assignment has no terminator")
        expression = text[assignment.end() : terminator]
        converted = _convert_dynamic_expression(expression)
        text = text[: assignment.end()] + converted + text[terminator:]
        search_from = assignment.end() + len(converted) + 1

    select_pattern = re.compile(r"\bSELECT\b", re.I)
    search_from = 0
    while True:
        masked = mask_non_executable(text)
        select = select_pattern.search(masked, search_from)
        if not select:
            return text
        terminator = masked.find(";", select.end())
        if terminator < 0:
            return text
        statement = text[select.start() : terminator]
        into = _top_level_keyword(statement, "INTO", len("SELECT"))
        if not into:
            search_from = terminator + 1
            continue
        after_into = mask_non_executable(statement[into.end() :])
        target = re.match(r"\s*([A-Z_$#][\w$#]*)\b", after_into, re.I)
        if not target or target.group(1).upper() not in variables:
            search_from = terminator + 1
            continue
        expression_start = select.end()
        expression_end = select.start() + into.start()
        expression = text[expression_start:expression_end]
        converted = _convert_dynamic_expression(expression)
        text = text[:expression_start] + converted + text[expression_end:]
        search_from = expression_start + len(converted) + 1


def _rewrite_execute_immediate(text: str) -> str:
    text = _rewrite_dynamic_variable_assignments(text, _dynamic_sql_variables(text))
    sequence = 1
    pattern = re.compile(r"\bEXECUTE\s+IMMEDIATE\b", re.I)
    while True:
        masked = mask_non_executable(text)
        statement = pattern.search(masked)
        if not statement:
            return text
        terminator = masked.find(";", statement.end())
        if terminator < 0:
            raise ValueError("EXECUTE IMMEDIATE has no terminator")
        tail = text[statement.end() : terminator]
        tail_masked = mask_non_executable(tail)
        into = _top_level_keyword(tail, "INTO")
        using = _top_level_keyword(tail, "USING")
        clause_starts = [
            match.start() for match in (into, using) if match is not None
        ]
        expression_end = min(clause_starts) if clause_starts else len(tail)
        expression = _convert_dynamic_expression(tail[:expression_end].strip())

        output_variables: list[str] = []
        if into is not None:
            into_end = using.start() if using and using.start() > into.start() else len(tail)
            output_variables = _split_sql_list(tail[into.end() : into_end])
        bind_values: list[str] = []
        if using is not None:
            using_end = into.start() if into and into.start() > using.start() else len(tail)
            bind_values = _split_sql_list(tail[using.end() : using_end])

        sql_variable = f"@BJTS_DYNAMIC_SQL_{sequence:03d}"
        statement_name = f"BJTS_DYNAMIC_STMT_{sequence:03d}"
        lines: list[str] = []
        if output_variables:
            output_names = [
                f"@BJTS_DYNAMIC_OUT_{sequence:03d}_{index:03d}"
                for index in range(1, len(output_variables) + 1)
            ]
            lines.extend(f"SET {name} = NULL;" for name in output_names)
            into_sql = ", ".join(output_names)
            lines.append(
                f"SET {sql_variable} = CONCAT("
                f"TRIM(TRAILING ';' FROM {expression}), "
                f"' INTO {into_sql}');"
            )
        else:
            lines.append(f"SET {sql_variable} = {expression};")
        lines.append(f"PREPARE {statement_name} FROM {sql_variable};")
        bind_names = [
            f"@BJTS_BIND_{sequence:03d}_{index:03d}"
            for index in range(1, len(bind_values) + 1)
        ]
        lines.extend(
            f"SET {name} = {value.strip()};"
            for name, value in zip(bind_names, bind_values)
        )
        execute = f"EXECUTE {statement_name}"
        if bind_names:
            execute += " USING " + ", ".join(bind_names)
        lines.append(execute + ";")
        lines.append(f"DEALLOCATE PREPARE {statement_name};")
        if output_variables:
            lines.extend(
                f"SET {variable.strip()} = {name};"
                for variable, name in zip(output_variables, output_names)
            )
        indent_match = re.search(r"(?m)^[ \t]*$", text[: statement.start()])
        replacement = "\n".join(lines)
        text = text[: statement.start()] + replacement + text[terminator + 1 :]
        sequence += 1


def _rownum_query_scope(masked: str, position: int) -> tuple[int, int]:
    stack: list[int] = []
    for index, char in enumerate(masked[:position]):
        if char == "(":
            stack.append(index)
        elif char == ")" and stack:
            stack.pop()
    for opening in reversed(stack):
        if re.match(r"\s*(?:SELECT|WITH)\b", masked[opening + 1 :], re.I):
            closing = _matching_parenthesis(masked, opening)
            if closing is None:
                raise ValueError("ROWNUM subquery has no closing parenthesis")
            return opening + 1, closing
    start = masked.rfind(";", 0, position) + 1
    end = masked.find(";", position)
    if end < 0:
        raise ValueError("ROWNUM statement has no terminator")
    return start, end


def _select_list_range(query: str) -> tuple[int, int] | None:
    select = _top_level_keyword(query, "SELECT")
    if not select:
        return None
    from_match = _top_level_keyword(query, "FROM", select.end())
    if not from_match:
        return None
    return select.end(), from_match.start()


def _cap_first_count(query: str) -> tuple[str, bool]:
    select_list = _select_list_range(query)
    if not select_list:
        return query, False
    start, end = select_list
    masked = mask_non_executable(query)
    count = re.search(r"\bCOUNT\s*\(", masked[start:end], re.I)
    if not count:
        return query, False
    opening = masked.find("(", start + count.start())
    closing = _matching_parenthesis(masked, opening)
    if closing is None or closing > end:
        raise ValueError("COUNT beside ROWNUM has unbalanced parentheses")
    expression = query[start + count.start() : closing + 1]
    replacement = f"LEAST({expression}, 1)"
    absolute_start = start + count.start()
    return query[:absolute_start] + replacement + query[closing + 1 :], True


def _append_limit(query: str, limit: int) -> str:
    masked = mask_non_executable(query)
    if re.search(r"\bLIMIT\s+\d+\s*$", masked, re.I):
        return query
    trailing_start = len(query.rstrip())
    return query[:trailing_start] + f"\nLIMIT {limit}" + query[trailing_start:]


def _rewrite_rownum(text: str) -> str:
    comparison = re.compile(r"\bROWNUM\s*(=|<=|<)\s*(\d+)\b", re.I)
    while True:
        masked = mask_non_executable(text)
        matches = list(comparison.finditer(masked))
        if not matches:
            break
        match = matches[-1]
        operator = match.group(1)
        bound = int(match.group(2))
        if operator == "=" and bound != 1:
            raise ValueError(f"unsupported ROWNUM equality bound: {bound}")
        limit = bound - 1 if operator == "<" else bound
        scope_start, scope_end = _rownum_query_scope(masked, match.start())
        query = text[scope_start:scope_end]
        relative_start = match.start() - scope_start
        relative_end = match.end() - scope_start
        query = query[:relative_start] + "1=1" + query[relative_end:]
        query, capped_count = _cap_first_count(query)
        if not capped_count:
            query = _append_limit(query, limit)
        text = text[:scope_start] + query + text[scope_end:]

    protected, replacements = _protect(text)
    protected = re.sub(
        r"\bROWNUM\b",
        "ROW_NUMBER() OVER ()",
        protected,
        flags=re.I,
    )
    return _restore(protected, replacements)


def _rewrite_dbms_output(text: str) -> str:
    protected, replacements = _protect(text)
    pattern = re.compile(
        r"\b(?:SYS\s*\.\s*)?DBMS_OUTPUT\s*\.\s*PUT_LINE\s*\(",
        re.I,
    )
    search_from = 0
    while True:
        call = pattern.search(protected, search_from)
        if not call:
            break
        opening = protected.find("(", call.start())
        closing = _matching_parenthesis(protected, opening)
        if closing is None:
            raise ValueError("DBMS_OUTPUT.PUT_LINE has no closing parenthesis")
        expression = protected[opening + 1 : closing].strip() or "0"
        replacement = f"DO {expression}"
        protected = protected[: call.start()] + replacement + protected[closing + 1 :]
        search_from = call.start() + len(replacement)
    return _restore(protected, replacements)


def _rewrite_raise_application_error(text: str) -> str:
    protected, replacements = _protect(text)
    protected = re.sub(
        r"\bRAISE_APPLICATION_ERROR\s*(?=\()",
        "CALL ORA_RAISE_APPLICATION_ERROR",
        protected,
        flags=re.I,
    )
    return _restore(protected, replacements)


def _merge_update_assignments(
    assignments: str,
    target_alias: str,
) -> str:
    converted: list[str] = []
    for assignment in _split_sql_list(assignments):
        match = re.match(
            rf"\s*(?:{re.escape(target_alias)}\s*\.\s*)?"
            r"([A-Z_$#][\w$#]*)\s*=\s*([\s\S]+?)\s*$",
            assignment,
            re.I,
        )
        if not match:
            raise ValueError(f"unsupported MERGE update assignment: {assignment.strip()}")
        converted.append(f"{match.group(1)} = {match.group(2).strip()}")
    return ", ".join(converted)


def _rewrite_merge(text: str) -> str:
    pattern = re.compile(r"\bMERGE\s+INTO\b", re.I)
    while True:
        masked = mask_non_executable(text)
        merge = pattern.search(masked)
        if not merge:
            return text
        terminator = masked.find(";", merge.end())
        if terminator < 0:
            raise ValueError("MERGE statement has no terminator")
        statement = text[merge.start() : terminator]
        statement_masked = mask_non_executable(statement)
        header = re.match(
            r"MERGE\s+INTO\s+([A-Z_$#][\w$#.]*)\s+"
            r"(?:AS\s+)?([A-Z_$#][\w$#]*)\s+USING\s*",
            statement_masked,
            re.I,
        )
        if not header:
            raise ValueError("unsupported MERGE target header")
        target_table = statement[header.start(1) : header.end(1)].strip()
        target_alias = header.group(2).upper()
        source_opening = statement_masked.find("(", header.end())
        if source_opening < 0:
            raise ValueError("MERGE USING source must be a parenthesized query")
        source_closing = _matching_parenthesis(statement_masked, source_opening)
        if source_closing is None:
            raise ValueError("MERGE USING query has no closing parenthesis")
        source_query = statement[source_opening + 1 : source_closing].strip()
        source_alias_match = re.match(
            r"\s*(?:AS\s+)?([A-Z_$#][\w$#]*)\s+ON\s*",
            statement_masked[source_closing + 1 :],
            re.I,
        )
        if not source_alias_match:
            raise ValueError("MERGE source query has no alias or ON clause")
        source_alias = source_alias_match.group(1).upper()
        on_search_start = source_closing + 1 + source_alias_match.end()
        on_opening = statement_masked.find("(", on_search_start)
        if on_opening < 0:
            raise ValueError("MERGE ON condition must be parenthesized")
        on_closing = _matching_parenthesis(statement_masked, on_opening)
        if on_closing is None:
            raise ValueError("MERGE ON condition has no closing parenthesis")
        condition = statement[on_opening + 1 : on_closing].strip()
        clauses = statement[on_closing + 1 :]
        clauses_masked = mask_non_executable(clauses)
        matched = re.search(
            r"\bWHEN\s+MATCHED\s+THEN\s+UPDATE\s+SET\b",
            clauses_masked,
            re.I,
        )
        not_matched = re.search(
            r"\bWHEN\s+NOT\s+MATCHED\s+THEN\s+INSERT\b",
            clauses_masked,
            re.I,
        )
        if not matched and not not_matched:
            raise ValueError("MERGE has neither matched nor not-matched action")

        generated: list[str] = []
        if matched:
            update_end = not_matched.start() if not_matched else len(clauses)
            assignments = clauses[matched.end() : update_end].strip()
            mysql_assignments = _merge_update_assignments(assignments, target_alias)
            generated.append(
                f"UPDATE {target_table} AS {target_alias}\n"
                f"JOIN (\n{source_query}\n) AS {source_alias}\n"
                f"ON {condition}\n"
                f"SET {mysql_assignments};"
            )

        if not_matched:
            insert_tail_start = not_matched.end()
            insert_opening = clauses_masked.find("(", insert_tail_start)
            if insert_opening < 0:
                raise ValueError("MERGE INSERT has no column list")
            insert_closing = _matching_parenthesis(clauses_masked, insert_opening)
            if insert_closing is None:
                raise ValueError("MERGE INSERT column list is unbalanced")
            columns = clauses[insert_opening + 1 : insert_closing].strip()
            values_keyword = re.match(
                r"\s*VALUES\s*",
                clauses_masked[insert_closing + 1 :],
                re.I,
            )
            if not values_keyword:
                raise ValueError("MERGE INSERT has no VALUES clause")
            values_search_start = insert_closing + 1 + values_keyword.end()
            values_opening = clauses_masked.find("(", values_search_start)
            if values_opening < 0:
                raise ValueError("MERGE VALUES has no opening parenthesis")
            values_closing = _matching_parenthesis(clauses_masked, values_opening)
            if values_closing is None:
                raise ValueError("MERGE VALUES list is unbalanced")
            values = clauses[values_opening + 1 : values_closing].strip()
            generated.append(
                f"INSERT INTO {target_table} ({columns})\n"
                f"SELECT {values}\n"
                f"FROM (\n{source_query}\n) AS {source_alias}\n"
                "WHERE NOT EXISTS (\n"
                f"  SELECT 1 FROM {target_table} AS {target_alias} "
                f"WHERE {condition}\n"
                ");"
            )

        replacement = "\n".join(generated)
        text = text[: merge.start()] + replacement + text[terminator + 1 :]


def _rewrite_rowid_deduplication(text: str) -> str:
    protected, replacements = _protect(text)
    pattern = re.compile(
        r"DELETE\s+FROM\s+CKTS_LC_SHXX_ZF\s+T\s+WHERE\s+EXISTS\s*\(\s*"
        r"SELECT\s+1\s+FROM\s+CKTS_LC_SHXX_ZF\s+S\s+WHERE\s+"
        r"S\.UUID\s*=\s*T\.UUID\s+AND\s+S\.ROWID\s*<\s*T\.ROWID\s*\)\s*;",
        re.I,
    )
    replacement = """DROP TEMPORARY TABLE IF EXISTS BJTS_TMP_CKTS_LC_SHXX_ZF;
    CREATE TEMPORARY TABLE BJTS_TMP_CKTS_LC_SHXX_ZF LIKE CKTS_LC_SHXX_ZF;
    ALTER TABLE BJTS_TMP_CKTS_LC_SHXX_ZF
        ADD UNIQUE KEY BJTS_UK_UUID (UUID);
    INSERT IGNORE INTO BJTS_TMP_CKTS_LC_SHXX_ZF
        SELECT * FROM CKTS_LC_SHXX_ZF;
    DELETE FROM CKTS_LC_SHXX_ZF;
    INSERT INTO CKTS_LC_SHXX_ZF
        SELECT * FROM BJTS_TMP_CKTS_LC_SHXX_ZF;
    DROP TEMPORARY TABLE BJTS_TMP_CKTS_LC_SHXX_ZF;"""
    protected, count = pattern.subn(replacement, protected)
    if count > 1:
        raise ValueError("unexpected duplicate ROWID deduplication statements")
    return _restore(protected, replacements)


def _rewrite_tuple_update_assignments(text: str) -> str:
    """Expand Oracle row assignments into MySQL scalar assignments."""

    search_from = 0
    tuple_set = re.compile(r"\bSET\s*\(", re.I)
    while True:
        masked = mask_non_executable(text)
        match = tuple_set.search(masked, search_from)
        if not match:
            return text

        statement_start = masked.rfind(";", 0, match.start()) + 1
        if not re.search(r"\bUPDATE\b", masked[statement_start : match.start()], re.I):
            search_from = match.end()
            continue

        lhs_opening = masked.find("(", match.start(), match.end())
        lhs_closing = _matching_parenthesis(masked, lhs_opening)
        if lhs_closing is None:
            raise ValueError("tuple UPDATE target list has no closing parenthesis")
        equals = re.match(r"\s*=\s*", masked[lhs_closing + 1 :])
        if not equals:
            raise ValueError("tuple UPDATE target list has no assignment operator")
        rhs_opening = lhs_closing + 1 + equals.end()
        if rhs_opening >= len(masked) or masked[rhs_opening] != "(":
            raise ValueError("tuple UPDATE source must be parenthesized")
        rhs_closing = _matching_parenthesis(masked, rhs_opening)
        if rhs_closing is None:
            raise ValueError("tuple UPDATE source has no closing parenthesis")

        columns = _split_sql_list(text[lhs_opening + 1 : lhs_closing])
        source = text[rhs_opening + 1 : rhs_closing]
        select = _top_level_keyword(source, "SELECT")
        expressions: list[str]
        query_tail = ""
        if select and not mask_non_executable(source[: select.start()]).strip():
            from_match = _top_level_keyword(source, "FROM", select.end())
            select_end = from_match.start() if from_match else len(source)
            expressions = _split_sql_list(source[select.end() : select_end])
            query_tail = source[select_end:].strip()
        else:
            expressions = _split_sql_list(source)

        if len(columns) != len(expressions):
            raise ValueError(
                "tuple UPDATE target/source count mismatch: "
                f"{len(columns)} target(s), {len(expressions)} value(s)"
            )

        assignments: list[str] = []
        for column, expression in zip(columns, expressions):
            value = expression.strip()
            if select:
                value = f"(SELECT {value}"
                if query_tail:
                    value += f"\n{query_tail}"
                value += ")"
            assignments.append(f"{column.strip()} = {value}")
        replacement = "SET " + ",\n           ".join(assignments)
        text = text[: match.start()] + replacement + text[rhs_closing + 1 :]
        search_from = match.start() + len(replacement)


def _update_statement_mysql_syntax(statement: str) -> str:
    masked = mask_non_executable(statement)
    update = re.search(r"\bUPDATE\b", masked, re.I)
    if not update:
        return statement
    set_match = _top_level_keyword(statement, "SET", update.end())
    if not set_match:
        return statement

    header = statement[: set_match.start()]
    masked_header = masked[: set_match.start()]
    target = re.match(
        r"\s*UPDATE\s+([A-Z_$#][\w$#.]*)"
        r"(?:\s+(AS\s+)?([A-Z_$#][\w$#]*))?",
        masked_header,
        re.I,
    )
    if not target:
        return statement
    table_name = target.group(1)
    alias = target.group(3)
    alias_keywords = {
        "CROSS",
        "FORCE",
        "IGNORE",
        "INNER",
        "JOIN",
        "LEFT",
        "RIGHT",
        "SET",
        "STRAIGHT_JOIN",
        "USE",
    }
    if alias and alias.upper() in alias_keywords:
        alias = None

    if alias and not target.group(2):
        alias_start = target.start(3)
        header = header[:alias_start] + "AS " + header[alias_start:]

    clause_end = len(statement)
    for keyword in ("WHERE", "ORDER", "LIMIT"):
        boundary = _top_level_keyword(statement, keyword, set_match.end())
        if boundary:
            clause_end = min(clause_end, boundary.start())
    assignment_sql = statement[set_match.end() : clause_end]
    qualifiers = [table_name.rsplit(".", 1)[-1]]
    if alias:
        qualifiers.insert(0, alias)
    qualifier_pattern = "|".join(re.escape(value) for value in qualifiers)
    assignments: list[str] = []
    for assignment in _split_sql_list(assignment_sql):
        assignment = re.sub(
            rf"^(\s*)(?:{qualifier_pattern})\s*\.\s*"
            r"([A-Z_$#][\w$#]*)(\s*=)",
            r"\1\2\3",
            assignment,
            count=1,
            flags=re.I,
        )
        assignments.append(assignment)
    separator = ",\n    " if "\n" in assignment_sql else ", "
    trailing_space = re.search(r"\s*$", assignment_sql)
    clause_space = trailing_space.group(0) if trailing_space else ""
    if clause_end < len(statement) and not clause_space:
        clause_space = " "
    return (
        header
        + statement[set_match.start() : set_match.end()]
        + " "
        + separator.join(assignments)
        + clause_space
        + statement[clause_end:]
    )


def _rewrite_mysql_dml_syntax(text: str) -> str:
    """Normalize Oracle target aliases and assignment targets for MySQL 8.0."""

    update_pattern = re.compile(r"(?im)^[ \t]*UPDATE\b")
    search_from = 0
    while True:
        masked = mask_non_executable(text)
        update = update_pattern.search(masked, search_from)
        if not update:
            break
        terminator = masked.find(";", update.end())
        if terminator < 0:
            raise ValueError("UPDATE statement has no terminator")
        statement = text[update.start() : terminator]
        replacement = _update_statement_mysql_syntax(statement)
        text = text[: update.start()] + replacement + text[terminator:]
        search_from = update.start() + len(replacement) + 1

    delete_pattern = re.compile(
        r"(?im)^[ \t]*DELETE\s+FROM\s+[A-Z_$#][\w$#.]*\s+"
        r"(?:(AS)\s+)?([A-Z_$#][\w$#]*)\b"
    )
    search_from = 0
    delete_alias_keywords = {"JOIN", "LIMIT", "ORDER", "USING", "WHERE"}
    while True:
        masked = mask_non_executable(text)
        delete = delete_pattern.search(masked, search_from)
        if not delete:
            break
        alias = delete.group(2)
        if delete.group(1) or alias.upper() in delete_alias_keywords:
            search_from = delete.end()
            continue
        alias_start = delete.start(2)
        text = text[:alias_start] + "AS " + text[alias_start:]
        search_from = delete.end() + 3
    return text


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
    header = _ensure_parameter_list(header, target_object_type, object_name)
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
    converted = "\n".join(line.rstrip(" \t") for line in converted.splitlines())
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


def _custom_collection_procedure_sql(
    object_name: str,
    object_spelling: str,
) -> str | None:
    if object_name == "FUNC_GET_XJ_SWJG":
        converted = f"""CREATE PROCEDURE {object_spelling}(IN P_SJ_SWCODE VARCHAR(4000))
routine_body: BEGIN
    IF SUBSTR(P_SJ_SWCODE, 1, 1) = '2' THEN
        SELECT VIR_SWJGDM AS SWJG_DM
          FROM DM_SWJG_VIRTUAL
         WHERE SWJG_DM = P_SJ_SWCODE
           AND YXBZ = 'Y'
           AND VIR_FLAG = '0';
    ELSE
        SELECT SWJG_DM AS SWJG_DM
          FROM DM_SWJG
         WHERE SWJG_DM_SJ = P_SJ_SWCODE
           AND TSJG_BZ = '1';
    END IF;
END {object_spelling};
"""
    elif object_name == "FUNC_STRSPLIT":
        converted = f"""CREATE PROCEDURE {object_spelling}(
    IN P_VALUE VARCHAR(4000),
    IN P_SPLIT VARCHAR(4000)
)
routine_body: BEGIN
    SET P_SPLIT = COALESCE(NULLIF(P_SPLIT, ''), ',');

    WITH RECURSIVE BJTS_SPLIT (TOKEN, REST_VALUE, DEPTH_NO) AS (
        SELECT CAST(NULL AS CHAR(4000)), P_VALUE, 0
        UNION ALL
        SELECT CASE
                   WHEN LOCATE(P_SPLIT, REST_VALUE) = 0 THEN REST_VALUE
                   ELSE LEFT(REST_VALUE, LOCATE(P_SPLIT, REST_VALUE) - 1)
               END,
               CASE
                   WHEN LOCATE(P_SPLIT, REST_VALUE) = 0 THEN NULL
                   ELSE SUBSTRING(
                       REST_VALUE,
                       LOCATE(P_SPLIT, REST_VALUE) + CHAR_LENGTH(P_SPLIT)
                   )
               END,
               DEPTH_NO + 1
          FROM BJTS_SPLIT
         WHERE REST_VALUE IS NOT NULL
           AND REST_VALUE <> ''
    )
    SELECT TOKEN AS COLUMN_VALUE
      FROM BJTS_SPLIT
     WHERE DEPTH_NO > 0
       AND TOKEN IS NOT NULL
       AND TOKEN <> '';
END {object_spelling};
"""
    else:
        return None
    return _wrap_routine(
        converted,
        source_object_type="FUNCTION",
        target_object_type="PROCEDURE",
        object_name=object_name,
    )


def convert_source(relative_path: str, source_bytes: bytes) -> ConversionResult:
    """Convert one source file and return its text plus conversion metadata."""

    source_text = source_bytes.decode("gb18030").replace("\r\n", "\n").replace("\r", "\n")
    source_object_type, object_name = _routine_metadata(source_text)
    executable_source = mask_non_executable(source_text)
    spelling_match = ROUTINE_PATTERN.search(executable_source)
    if not spelling_match:
        raise ValueError(f"cannot locate source object spelling for {relative_path}")
    object_spelling = source_text[spelling_match.start(2) : spelling_match.end(2)]
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
    custom_sql = _custom_collection_procedure_sql(object_name, object_spelling)
    if custom_sql is not None:
        return ConversionResult(
            sql=custom_sql,
            source_object_type=source_object_type,
            target_object_type=target_object_type,
            object_name=object_name,
            warnings=warnings,
        )
    converted = convert_fragment(source_text)
    converted = _convert_routine_structure(
        converted,
        source_text=source_text,
        source_object_type=source_object_type,
        target_object_type=target_object_type,
        object_name=object_name,
    )
    converted = _rewrite_xj_swjg_table_calls(converted)
    converted = _rewrite_split_table_calls(converted)
    if object_name in COLLECTION_RESULT_COLUMNS:
        converted = _rewrite_collection_result_procedure(converted, object_name)
    if object_name == "TEMP_DATA_INIT":
        converted = _rewrite_temp_data_init(converted)
    converted = _rewrite_exception_blocks(converted)
    converted = _rewrite_while_loops(converted)
    converted = _rewrite_numeric_for_loops(converted)
    converted = _rewrite_open_fetch_loops(converted)
    converted = _rewrite_named_cursor_loops(converted)
    converted = _rewrite_implicit_cursor_loops(converted)
    converted = _rewrite_plain_loops(converted)
    converted = _rewrite_execute_immediate(converted)
    converted = _rewrite_function_procedure_assignments(converted)
    converted = _rewrite_procedure_calls(converted)
    converted = _rewrite_concatenation(converted)
    converted = _rewrite_date_arithmetic(converted, _date_identifiers(source_text))
    converted = _rewrite_raise_application_error(converted)
    converted = _rewrite_dbms_output(converted)
    converted = _rewrite_rownum(converted)
    converted = _rewrite_merge(converted)
    converted = _rewrite_rowid_deduplication(converted)
    converted = _rewrite_tuple_update_assignments(converted)
    converted = _rewrite_mysql_dml_syntax(converted)
    converted = _escape_mysql_string_backslashes(converted)
    converted = _normalize_mysql_line_comments(converted)
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
