# Oracle routines to TDSQL-C MySQL 8.0 design

## Goal

Convert every Oracle function and stored-procedure SQL file under
`bjts/tl_admin`, `bjts/tl_bjts`, and `bjts/tl_tssh` into a first-round
TDSQL-C MySQL 8.0 script while preserving business intent and source-file
traceability.

The source set at commit `efa52c4` contains 356 SQL files and 59,082 lines:

- `bjts/tl_admin`: 96 files
- `bjts/tl_bjts`: 114 files
- `bjts/tl_tssh`: 146 files

The first-round deliverable is intended for compilation on a separate machine
chosen by the user. Database-backed compilation and business-data equivalence
testing are explicitly outside this round because the current machine has no
MySQL or TDSQL-C service.

## Target and compatibility baseline

The target is TDSQL-C for MySQL 8.0. Generated routines use community MySQL
8.0 syntax supported by TDSQL-C. MySQL-supported window functions such as
`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, and `LEAD` remain window functions.

The three Oracle schemas are merged into one target database. SQL identifier
prefixes `TL_ADMIN.`, `TL_BJTS.`, and `TL_TSSH.` are removed. Text inside
comments and string literals is not blindly rewritten.

## Output structure

Source files remain unchanged. Each source file produces one same-named file:

| Oracle source | MySQL output |
|---|---|
| `bjts/tl_admin/*.sql` | `bjts/mysql_tl_admin/*.sql` |
| `bjts/tl_bjts/*.sql` | `bjts/mysql_tl_bjts/*.sql` |
| `bjts/tl_tssh/*.sql` | `bjts/mysql_tl_tssh/*.sql` |

All generated scripts use UTF-8 text and MySQL client-compatible `DELIMITER`,
`DROP ... IF EXISTS`, and `CREATE PROCEDURE` or `CREATE FUNCTION` statements.
Backup, temporary, and historical SQL files are included rather than filtered.

Shared migration objects are delivered in:

- `bjts/mysql_added/mysql_extra.sql`
- `bjts/mysql_added/SetOutputFuncList.txt`

`SetOutputFuncList.txt` is sorted by object name and contains one name per line.
It includes every Oracle function whose target object must be a MySQL stored
procedure.

## Routine conversion rules

### Declarations and procedural syntax

- Convert PL/SQL routine headers, parameter modes, declarations, assignments,
  control flow, and terminators to MySQL stored-routine syntax.
- Place MySQL declarations in the required order: local variables, cursors,
  then handlers.
- Replace `SQL%ROWCOUNT` with `ROW_COUNT()`.
- Replace scoped Oracle exception blocks with scoped MySQL handlers. Preserve
  distinct inner and outer error behavior where the Oracle source distinguishes
  it.
- Convert `REF CURSOR` outputs to procedure result sets. Multiple output cursors
  produce multiple result sets in original parameter order.
- Keep explicit cursors and nested cursors when MySQL can express the behavior.
  Each nested cursor block has its own completion flag and `NOT FOUND` handler
  so an inner cursor cannot terminate an outer loop.
- Convert dynamic SQL in procedures to `PREPARE`, `EXECUTE`, and
  `DEALLOCATE PREPARE`. Introduce a temporary table only when MySQL has no
  direct result-flow equivalent.

### Functions that must become procedures

Oracle collection-returning and pipelined functions cannot be represented as
MySQL scalar functions. Application-facing list functions become same-named
procedures that return result sets. Internal `TABLE(function(...))` expressions
are rewritten as equivalent subqueries, recursive CTEs, or predicates.

An Oracle function also becomes a procedure when it has `OUT` parameters,
returns a cursor or collection, emits a result set, uses dynamic SQL forbidden
inside MySQL functions, or requires transaction control forbidden inside a
MySQL function. Every such object is recorded in `SetOutputFuncList.txt`.

Scalar functions remain functions whenever MySQL permits their behavior and
signature.

### SQL expressions

- Convert `NVL`, `NVL2`, and `DECODE` to type-appropriate `IFNULL`, `CASE`, or
  equivalent expressions.
- Convert Oracle concatenation to explicit MySQL expressions that preserve the
  source's null-as-empty behavior where applicable.
- Convert `SYSDATE`, `SYSTIMESTAMP`, `TO_DATE`, `TO_CHAR`, `TRUNC`,
  `ADD_MONTHS`, `MONTHS_BETWEEN`, `LAST_DAY`, and Oracle date subtraction to
  MySQL date/time expressions with the same unit and precision.
- Remove `DUAL` where it is unnecessary.
- Convert `ROWNUM` to `LIMIT` only when the Oracle evaluation order permits it;
  otherwise use a derived table and `ROW_NUMBER()`.
- Convert `MERGE` to `INSERT ... ON DUPLICATE KEY UPDATE` when a matching unique
  key is known. Otherwise use explicit update-then-insert logic.
- Convert remaining Oracle-specific `DBMS_*`, regular-expression, conversion,
  and string functions individually rather than relying on an Oracle SQL mode.

### Numeric types

- `NUMBER(p)` and `NUMBER(p,0)` with `p <= 18` become signed `BIGINT`.
- `NUMBER(p)` and `NUMBER(p,0)` with `p > 18` become `DECIMAL(p,0)` because a
  signed MySQL `BIGINT` cannot represent every 19-digit integer.
- `NUMBER(p,s)` with nonzero scale becomes exact `DECIMAL(p,s)`, not `FLOAT` or
  `DOUBLE`.
- An unconstrained `NUMBER` is mapped from its use: identifiers and integer
  counters use an exact integer-compatible decimal; money, ratios, and computed
  values use an exact decimal with sufficient scale.
- The source routines contain 21 occurrences of `NUMBER(20)`; these become
  `DECIMAL(20,0)`. The observed explicit fractional types require no more than
  precision 18 and scale 6.

## Sequence compatibility layer

`mysql_extra.sql` creates the shared sequence state table with the requested
columns and a primary key needed for atomic name lookup:

```sql
CREATE TABLE sys_sequence (
    SEQ_NAME VARCHAR(100) NOT NULL,
    SEQ_VALUE BIGINT NOT NULL,
    PRIMARY KEY (SEQ_NAME)
);
```

It also creates `SEQ_NEXTVAL(sequence_name)`, which increments one sequence row
atomically and returns the allocated value. Oracle expressions such as
`SEQ_YJ_DATA_YJXX.NEXTVAL` become
`SEQ_NEXTVAL('SEQ_YJ_DATA_YJXX')`.

Sequence names used by the 356 routines are pre-seeded from the `START WITH`
values in the checked-in Oracle object exports. When duplicate sequence names
exist across merged schemas, the highest applicable exported value is used.
Before production cutover, operators must replace these snapshot values with
the final Oracle sequence positions.

The existing `F_SEQ_NEXTVAL_ADMIN` routine is retained as a compatibility
wrapper over the shared sequence mechanism.

## First-round static verification

This round does not install or start a database server and does not claim
database-backed compilation. It performs all checks possible without a server:

1. Assert output counts of 96, 114, and 146 and exact source/output filename
   equality.
2. Assert every output file is valid UTF-8 and nonempty.
3. Check that each file contains one expected MySQL routine definition and
   client delimiter wrapper.
4. Scan executable SQL for residual Oracle schema prefixes, routine headers,
   datatypes, sequence syntax, exception syntax, cursor attributes, and known
   Oracle-only functions.
5. Review every residual match and either convert it or classify it as comment
   or string content.
6. Check that every function-to-procedure conversion appears exactly once in
   `SetOutputFuncList.txt`.
7. Check sequence names in converted routines against seed names and the
   compatibility function.

The user will compile the pushed first-round scripts on another MySQL 8.0 or
TDSQL-C machine. Compiler diagnostics from that environment form the input to a
subsequent correction round.

## Version-control handling

Only task-related files are staged. Existing untracked HAR files are left
untouched. Before the final push, fetch the remote state, verify the generated
file manifest and static checks, commit the migration outputs, and push the
result to `origin/main` without force.
