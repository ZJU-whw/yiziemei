# Oracle Routines to TDSQL-C MySQL 8.0 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produce a first-round MySQL 8.0 conversion of all 356 Oracle routine files, the shared sequence compatibility layer, and the function-to-procedure inventory, then push the reviewed static output to `origin/main`.

**Architecture:** A small standard-library Python conversion tool performs repeatable encoding, lexical protection, routine-wrapper, datatype, schema, and common SQL rewrites. Complex PL/SQL behavior is then corrected by schema-focused passes, with a separate verifier enforcing the complete source/output manifest and detecting executable Oracle residue while ignoring comments and literals.

**Tech Stack:** Python 3 standard library and `unittest`, MySQL 8.0 stored-routine SQL, POSIX shell tools (`rg`, `iconv`, `find`), and Git.

**Spec:** `docs/superpowers/specs/2026-09-08-oracle-to-tdsqlc-routines-design.md`

## Global Constraints

- Target TDSQL-C for MySQL 8.0 and use community MySQL 8.0-compatible syntax.
- Do not modify any file under `bjts/tl_admin`, `bjts/tl_bjts`, or `bjts/tl_tssh`.
- Emit exactly 96, 114, and 146 same-named SQL files under `bjts/mysql_tl_admin`, `bjts/mysql_tl_bjts`, and `bjts/mysql_tl_tssh` respectively.
- Emit every generated SQL file as nonempty UTF-8 text with MySQL client delimiter wrappers.
- Remove `TL_ADMIN.`, `TL_BJTS.`, and `TL_TSSH.` from executable identifiers because all three schemas merge into one target database.
- Keep MySQL-supported window functions and preserve explicit and nested cursors whenever MySQL can express the behavior.
- Convert Oracle table/collection functions and every other function forbidden by MySQL routine restrictions into same-named procedures and list them in `bjts/mysql_added/SetOutputFuncList.txt`.
- Map integral `NUMBER` precision up to 18 to `BIGINT`; map integral precision above 18 to `DECIMAL(p,0)`; preserve fractional values with exact `DECIMAL(p,s)`.
- Create all shared tables, functions, and procedures in `bjts/mysql_added/mysql_extra.sql`.
- This is a static first round: do not claim MySQL/TDSQL-C compilation or business equivalence without the user's external compiler results.
- Preserve the existing untracked HAR files, stage only task-related paths, and push `origin/main` without force after all static checks pass.

---

### Task 1: Lock the source manifest and verification contract

**Files:**
- Create: `tools/bjts_sql_migration/__init__.py`
- Create: `tools/bjts_sql_migration/source_manifest.json`
- Create: `tools/bjts_sql_migration/verifier.py`
- Create: `tools/bjts_sql_migration/tests/__init__.py`
- Create: `tools/bjts_sql_migration/tests/test_verifier.py`

**Interfaces:**
- Consumes: the three immutable Oracle source directories and the output mapping in the spec.
- Produces: `load_manifest() -> dict[str, list[str]]`, `compare_manifest(repo_root: Path) -> list[str]`, `scan_output_file(path: Path) -> list[Finding]`, and a command-line verifier returning exit status 0 only when every static contract passes.

- [x] **Step 1: Write failing manifest tests**

```python
class ManifestTests(unittest.TestCase):
    def test_source_counts_are_locked(self):
        manifest = load_manifest(REPO_ROOT)
        self.assertEqual(96, len(manifest["tl_admin"]))
        self.assertEqual(114, len(manifest["tl_bjts"]))
        self.assertEqual(146, len(manifest["tl_tssh"]))

    def test_outputs_match_source_names(self):
        self.assertEqual([], compare_manifest(REPO_ROOT))
```

- [x] **Step 2: Run tests and confirm the output test fails**

Run: `python3 -m unittest tools.bjts_sql_migration.tests.test_verifier -v`

Expected: source-count test passes; output-manifest test fails because the three MySQL directories do not yet exist.

- [x] **Step 3: Record every exact source basename in the manifest**

Generate `source_manifest.json` from sorted `*.sql` basenames and review that it contains only the keys `tl_admin`, `tl_bjts`, and `tl_tssh`, with no duplicate basename inside a source directory.

- [x] **Step 4: Implement lexical masking and manifest checks**

`scan_output_file` must mask `--` comments, `/* ... */` comments, and quoted string literals before searching executable text. It must report line-numbered findings for Oracle routine headers, `VARCHAR2`, `NUMBER(...)`, `%ROWTYPE`, `%NOTFOUND`, `EXCEPTION`, `.NEXTVAL`, `.CURRVAL`, schema prefixes, standalone `/`, and known Oracle-only functions.

- [x] **Step 5: Run the verifier unit tests**

Run: `python3 -m unittest discover -s tools/bjts_sql_migration/tests -v`

Expected: all lexical-scanner tests pass; the integration output-manifest assertion remains an expected failure until generated outputs exist.

- [x] **Step 6: Commit the verification contract**

```bash
git add tools/bjts_sql_migration
git commit -m "test: define bjts SQL migration manifest"
```

### Task 2: Build the repeatable common conversion pass

**Files:**
- Create: `tools/bjts_sql_migration/converter.py`
- Create: `tools/bjts_sql_migration/tests/test_converter.py`
- Create: all files under `bjts/mysql_tl_admin`, `bjts/mysql_tl_bjts`, and `bjts/mysql_tl_tssh` from the locked manifest.

**Interfaces:**
- Consumes: `convert_source(relative_path: str, source_bytes: bytes) -> ConversionResult` where input text is GB18030-compatible Oracle PL/SQL.
- Produces: `ConversionResult(sql: str, source_object_type: str, target_object_type: str, object_name: str, warnings: list[str])` and UTF-8 same-named baseline files.

- [x] **Step 1: Write failing focused conversion tests**

Cover exact examples for GB18030-to-UTF-8 decoding, comment/string preservation, schema-prefix removal in executable identifiers, `NUMBER(18)` versus `NUMBER(20)`, `VARCHAR2`, sequence calls, `SQL%ROWCOUNT`, and routine wrappers:

```python
def test_integral_number_precision_boundary(self):
    converted = convert_fragment("a NUMBER(18); b NUMBER(20);")
    self.assertIn("a BIGINT;", converted)
    self.assertIn("b DECIMAL(20,0);", converted)

def test_schema_names_inside_literals_are_preserved(self):
    converted = convert_fragment("SELECT * FROM TL_ADMIN.T1; -- TL_ADMIN.T2\nSET s='TL_ADMIN.T3';")
    self.assertIn("FROM T1", converted)
    self.assertIn("-- TL_ADMIN.T2", converted)
    self.assertIn("'TL_ADMIN.T3'", converted)
```

- [x] **Step 2: Verify converter tests fail before implementation**

Run: `python3 -m unittest tools.bjts_sql_migration.tests.test_converter -v`

Expected: failure because `converter.py` and its public functions do not yet exist.

- [x] **Step 3: Implement protected-segment tokenization and encoding conversion**

Decode source bytes as GB18030, normalize CRLF to LF, preserve comments and quoted literals as protected segments, and apply identifier/keyword rewrites only to executable segments unless a later dynamic-SQL conversion explicitly opts into string-content rewriting.

- [x] **Step 4: Implement common routine and datatype conversion**

Recognize the single top-level Oracle function or procedure, build a MySQL `DROP ... IF EXISTS` plus `DELIMITER $$` wrapper, convert parameter modes and declaration syntax, apply the exact numeric mapping from the global constraints, and convert common assignments and row-count expressions.

- [x] **Step 5: Implement common SQL expression conversion**

Convert sequences to `SEQ_NEXTVAL('NAME')`, schema identifiers to unqualified names, simple `NVL/NVL2/DECODE`, `SYSDATE`, `DUAL`, and unambiguous `ROWNUM = 1` patterns. Emit a warning rather than guessing when nesting or Oracle evaluation order makes a mechanical conversion unsafe.

- [x] **Step 6: Generate all baseline output files**

Run: `python3 -m tools.bjts_sql_migration.converter --repo-root . --write`

Expected: exactly 356 UTF-8 SQL files are written into the three requested output directories; source hashes remain unchanged.

- [x] **Step 7: Run unit and manifest tests**

Run: `python3 -m unittest discover -s tools/bjts_sql_migration/tests -v`

Expected: all converter tests and exact filename/count checks pass; residual scans may still fail and drive Tasks 4–6.

- [x] **Step 8: Commit the baseline converter and generated files**

```bash
git add tools/bjts_sql_migration/converter.py tools/bjts_sql_migration/tests/test_converter.py bjts/mysql_tl_admin bjts/mysql_tl_bjts bjts/mysql_tl_tssh
git commit -m "feat: generate baseline MySQL routines"
```

### Task 3: Implement the shared sequence layer and conversion inventory

**Files:**
- Create: `bjts/mysql_added/mysql_extra.sql`
- Create: `bjts/mysql_added/SetOutputFuncList.txt`
- Create: `tools/bjts_sql_migration/tests/test_extra_objects.py`
- Modify: `bjts/mysql_tl_bjts/F_SEQ_NEXTVAL_ADMIN.sql`

**Interfaces:**
- Consumes: every distinct executable `.NEXTVAL` reference and exported Oracle `START WITH` value.
- Produces: `SEQ_NEXTVAL(p_seq_name VARCHAR(100)) RETURNS BIGINT`, a `sys_sequence(SEQ_NAME, SEQ_VALUE)` table with a primary key, seed rows representing the value immediately before the exported next value, and a sorted function-to-procedure name list.

- [x] **Step 1: Write failing sequence-contract tests**

```python
def test_every_converted_sequence_call_has_a_seed(self):
    self.assertEqual(sequence_calls(OUTPUT_DIRS), sequence_seeds(EXTRA_SQL))

def test_output_function_list_is_sorted_and_unique(self):
    names = OUTPUT_LIST.read_text(encoding="utf-8").splitlines()
    self.assertEqual(sorted(set(names), key=str.upper), names)
```

- [x] **Step 2: Run the tests and confirm missing-object failures**

Run: `python3 -m unittest tools.bjts_sql_migration.tests.test_extra_objects -v`

Expected: failure because `mysql_extra.sql` and `SetOutputFuncList.txt` do not exist.

- [x] **Step 3: Create the atomic sequence table and function**

Use a primary key on `SEQ_NAME` and an `INSERT ... ON DUPLICATE KEY UPDATE` expression with `LAST_INSERT_ID` to allocate one value atomically. Declare `MODIFIES SQL DATA` and document that TDSQL-C may require `log_bin_trust_function_creators` or equivalent routine-creation privilege.

- [x] **Step 4: Seed all used sequence names from checked-in exports**

For each used name, seed `START WITH - 1` so the first call returns the exported next value. Resolve the merged-schema duplicate `SEQ_TB_TBPC` with the applicable higher exported position `34395505`.

- [x] **Step 5: Convert and retain `F_SEQ_NEXTVAL_ADMIN`**

Replace its old `TBLNAME/CURVALUE` table access and autonomous transaction with a scalar compatibility wrapper calling `SEQ_NEXTVAL(UPPER(p_table_name))`. Do not issue `COMMIT` inside the function.

- [x] **Step 6: Populate the function-to-procedure list from conversion metadata**

Write only uppercase object names, one per line, sorted and unique. Verify every listed file defines a procedure and every source function converted to a procedure is listed.

- [x] **Step 7: Run extra-object tests and commit**

Run: `python3 -m unittest tools.bjts_sql_migration.tests.test_extra_objects -v`

Expected: all sequence coverage and inventory tests pass.

```bash
git add bjts/mysql_added bjts/mysql_tl_bjts/F_SEQ_NEXTVAL_ADMIN.sql tools/bjts_sql_migration/tests/test_extra_objects.py
git commit -m "feat: add MySQL sequence compatibility layer"
```

### Task 4: Complete and review the `tl_admin` conversion

**Files:**
- Modify: all 96 files under `bjts/mysql_tl_admin`
- Modify: `bjts/mysql_added/SetOutputFuncList.txt`
- Modify: `tools/bjts_sql_migration/tests/test_converter.py`

**Interfaces:**
- Consumes: the 96 `tl_admin` Oracle sources and common compatibility objects.
- Produces: 96 statically clean MySQL routines, including an equivalent result-set procedure for `FUNC_GET_XJ_SWJG` and rewritten internal callers.

- [x] **Step 1: Add failing regression fixtures for admin-specific constructs**

Cover `TABLE(FUNC_GET_XJ_SWJG(...))`, cursor declaration order, scoped handlers, report-period date calculations, schema removal, DML functions, and `ROWNUM` ordering.

- [x] **Step 2: Run focused tests and save the expected failures**

Run: `python3 -m unittest tools.bjts_sql_migration.tests.test_converter.AdminRoutineTests -v`

Expected: failures identify each still-unhandled construct rather than a generic text mismatch.

- [x] **Step 3: Convert `FUNC_GET_XJ_SWJG` and every SQL caller**

Make the target object a procedure returning the correct one-column result set. Replace internal Oracle table-function predicates with the direct `DM_SWJG_VIRTUAL`/`DM_SWJG` union logic selected by the parent-code rule, without introducing a temporary table.

- [x] **Step 4: Convert procedural and SQL differences across the remaining files**

Correct declaration order, loops, handlers, date formatting/arithmetic, null-preserving concatenation, DML target aliases, `ROWNUM`, aggregate selects, and transaction statements. Convert admin scalar DML functions to procedures only when MySQL function restrictions require it and update the inventory.

- [x] **Step 5: Run admin residual and structure verification**

Run: `python3 -m tools.bjts_sql_migration.verifier --repo-root . --schema tl_admin`

Expected: exact 96-file manifest, UTF-8, wrappers, object names, and executable-residue checks all pass.

- [x] **Step 6: Commit the completed admin batch**

```bash
git add bjts/mysql_tl_admin bjts/mysql_added/SetOutputFuncList.txt tools/bjts_sql_migration/tests/test_converter.py
git commit -m "feat: convert tl_admin routines to MySQL 8.0"
```

### Task 5: Complete and review the `tl_bjts` conversion

**Files:**
- Modify: all 114 files under `bjts/mysql_tl_bjts`
- Modify: `bjts/mysql_added/SetOutputFuncList.txt`
- Modify: `tools/bjts_sql_migration/tests/test_converter.py`

**Interfaces:**
- Consumes: the 114 `tl_bjts` Oracle sources, the sequence layer, and the approved collection-function policy.
- Produces: 114 statically clean MySQL routines; list-returning functions become result-set procedures and `FUNC_STRSPLIT` consumers use a recursive CTE or `JSON_TABLE` equivalent.

- [x] **Step 1: Add failing bjts-specific regression fixtures**

Cover collection constructors, pipelined `FUNC_STRSPLIT`, parameterized cursors, ref cursors, dynamic SQL, `EXECUTE IMMEDIATE ... INTO`, DML functions with commits, exception return paths, and repeated sequence allocation in `INSERT ... SELECT`.

- [x] **Step 2: Convert collection and pipelined functions**

Convert `FUNC_GET_SBHZXX*`, `FUNC_GET_SBLIST*`, `FUNC_GET_WJDR_SBLIST*`, `FUNC_SHZS_RWWP*`, and `FUNC_STRSPLIT` to result-set procedures or direct internal CTE logic. Preserve output column order and aliases from the Oracle object types.

- [x] **Step 3: Convert forbidden scalar-function behavior**

Convert functions containing forbidden dynamic SQL, output parameters, result sets, or transaction control to procedures. Add a final OUT parameter when needed to carry the original scalar return value, and record each renamed object type in the inventory without changing its object name.

- [x] **Step 4: Convert all remaining procedures**

Handle dynamic statements, cursor loops, handlers, `MERGE`, date math, null semantics, row limiting, sequence calls, and MySQL DML alias rules across all `PROC_XXBD_*`, ETL, daily, and temporary routines.

- [x] **Step 5: Run bjts residual and structure verification**

Run: `python3 -m tools.bjts_sql_migration.verifier --repo-root . --schema tl_bjts`

Expected: exact 114-file manifest, UTF-8, wrappers, object names, inventory, sequence coverage, and executable-residue checks all pass.

- [x] **Step 6: Commit the completed bjts batch**

```bash
git add bjts/mysql_tl_bjts bjts/mysql_added tools/bjts_sql_migration/tests/test_converter.py
git commit -m "feat: convert tl_bjts routines to MySQL 8.0"
```

### Task 6: Complete and review the `tl_tssh` conversion

**Files:**
- Modify: all 146 files under `bjts/mysql_tl_tssh`
- Modify: `bjts/mysql_added/SetOutputFuncList.txt`
- Modify: `tools/bjts_sql_migration/tests/test_converter.py`

**Interfaces:**
- Consumes: the 146 `tl_tssh` Oracle sources and the shared sequence layer.
- Produces: 146 statically clean MySQL routines, retaining window functions and properly scoped nested cursors in large ETL and indicator procedures.

- [x] **Step 1: Add failing tssh-specific regression fixtures**

Cover nested cursors, large scoped exception blocks, Oracle date literals, interval arithmetic, regex extraction, dynamic DDL, `MERGE`, analytic functions, sequence calls in select lists, and multi-level `CASE/DECODE` expressions.

- [x] **Step 2: Convert scalar extraction and indicator functions**

Keep legal scalar routines as functions with explicit MySQL characteristics. Convert `F_MY_STDAVG_TMPTB` to a result/OUT procedure because MySQL functions cannot use its dynamic DDL and prepared statements; record it in the inventory.

- [x] **Step 3: Convert the small indicator procedure family**

Convert all `PRO_JKGL_COMPUTE_S*` and `PRO_JKGL_COMPUTE_W*` files with consistent date, row-limit, handler, upsert, and transaction rules while preserving existing window functions.

- [x] **Step 4: Convert the large and nested-cursor procedures**

Work through `PRO_DEAL_AFTER_ETL`, `ORIGINAL_JKGL_DATA_TJ_ZBU`, `PRO_JKGL_COMPUTE_ZB*`, `PRO_JKGL_JKM_*`, risk-analysis routines, and `TEMP_*` scripts block by block. Give each cursor nesting level a local completion flag and handler.

- [x] **Step 5: Run tssh residual and structure verification**

Run: `python3 -m tools.bjts_sql_migration.verifier --repo-root . --schema tl_tssh`

Expected: exact 146-file manifest, UTF-8, wrappers, object names, inventory, sequence coverage, and executable-residue checks all pass.

- [x] **Step 6: Commit the completed tssh batch**

```bash
git add bjts/mysql_tl_tssh bjts/mysql_added tools/bjts_sql_migration/tests/test_converter.py
git commit -m "feat: convert tl_tssh routines to MySQL 8.0"
```

### Task 7: Perform the complete static audit

**Files:**
- Modify: any failing file under the four requested `bjts/mysql_*` directories
- Modify: `tools/bjts_sql_migration/verifier.py`
- Modify: `tools/bjts_sql_migration/tests/test_verifier.py`

**Interfaces:**
- Consumes: all 356 converted scripts, `mysql_extra.sql`, and `SetOutputFuncList.txt`.
- Produces: a zero-exit full verifier run with every residual finding reviewed as executable SQL or safely masked comment/literal text.

- [x] **Step 1: Run the complete unit suite**

Run: `python3 -m unittest discover -s tools/bjts_sql_migration/tests -v`

Expected: all tests pass.

- [x] **Step 2: Run the full static verifier**

Run: `python3 -m tools.bjts_sql_migration.verifier --repo-root .`

Expected: `356/356 output files verified; 0 executable Oracle residue findings` and exit status 0.

- [x] **Step 3: Run independent shell checks**

```bash
find bjts/mysql_tl_admin -maxdepth 1 -type f -name '*.sql' | wc -l
find bjts/mysql_tl_bjts -maxdepth 1 -type f -name '*.sql' | wc -l
find bjts/mysql_tl_tssh -maxdepth 1 -type f -name '*.sql' | wc -l
git diff --check
```

Expected counts: `96`, `114`, `146`; `git diff --check` emits no output.

- [x] **Step 4: Review representative high-risk diffs against Oracle sources**

Review at least one nested-cursor routine, one dynamic-SQL routine, one `MERGE` routine, one analytic-query routine, one list-returning function converted to a procedure, and one sequence-heavy insert. Confirm parameter order, output-column order, transaction boundaries, and condition precedence.

- [x] **Step 5: Confirm unrelated files remain untouched**

Run: `git status --short`

Expected: the three pre-existing HAR files remain untracked and are not staged; only migration-related tracked changes appear.

- [x] **Step 6: Commit audit fixes**

```bash
git add bjts/mysql_tl_admin bjts/mysql_tl_bjts bjts/mysql_tl_tssh bjts/mysql_added tools/bjts_sql_migration
git commit -m "fix: complete static audit of converted routines"
```

If there are no audit fixes, do not create an empty commit.

### Task 8: Synchronize and push the first-round conversion

**Files:**
- Verify only; no intended file changes.

**Interfaces:**
- Consumes: the passing static audit and local commits.
- Produces: the same commits on `origin/main`, without force-pushing or staging unrelated files.

- [x] **Step 1: Fetch and inspect remote divergence**

Run: `git fetch origin` followed by `git status --short --branch` and `git log --oneline --left-right HEAD...origin/main`.

Expected: either no remote-only commits or a clearly reviewable set to rebase onto before pushing.

- [x] **Step 2: Re-run verification after synchronization**

Run: `python3 -m unittest discover -s tools/bjts_sql_migration/tests -v` and `python3 -m tools.bjts_sql_migration.verifier --repo-root .`.

Expected: all tests pass and the verifier reports all 356 outputs clean.

- [ ] **Step 3: Push without force**

Run: `git push origin main`

Expected: push succeeds and reports the new `main` tip.

- [ ] **Step 4: Verify the remote tip**

Run: `git ls-remote --heads origin main` and compare its object ID with `git rev-parse HEAD`.

Expected: both object IDs are identical.
