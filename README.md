# Shared recipes for common tooling in PHP projects

This is a collection of recipes for [just](https://just.systems/), making interactions
with common tools in PHP development a bit easier.

## clean

Clean up build artifacts

## decomposer [dev]

Install dependencies with [decomposer](github.com/framna-nl-backend/decomposer)

Examples:
```bash
# Install production dependencies
just decomposer

# Install production + development-only dependencies
just decomposer dev
```

## phpcs [\<standard\>] [\<bootstrap file\>] [\<installed_paths\>]

Run `phpcs` to verify the defined coding standard. If no standard is selected it will
pick `/var/www/libs/lunr-coding-standard/Lunr/` by default. You can override this with
either a `LUNR_CODING_STANDARD` environment variable, or a `default_coding_standard` just
variable.

You can specify a `bootstrap file` and/or define custom `installed_paths` if your coding
standard needs them.

The recipe will automatically pass `--report-checkstyle=build/logs/checkstyle.xml` to phpcs
if it detects that it's run from GitHub Actions.

Examples:
```bash
# Check against the "PSR12" standard
just phpcs PSR12

# Check against the "Lunr" standard, specify the bootstrap file to use and with installed_paths to set
just phpcs Lunr bootstrap.php third-party/slevomat/
```

## phpcbf [\<standard\>] [\<bootstrap file\>] [\<installed_paths\>]

Run `phpcbf` to automatically fix code to conform to the defined coding standard. If no
standard is selected it will pick `/var/www/libs/lunr-coding-standard/Lunr/` by default.
You can override this with either a `LUNR_CODING_STANDARD` environment variable, or a
`default_coding_standard` just variable.

You can specify a `bootstrap file` and/or define custom `installed_paths` if your coding
standard needs them.

Examples:
```bash
# Check against the "PSR12" standard
just phpcbf PSR12

# Check against the "Lunr" standard, specify the bootstrap file to use and with installed_paths to set
just phpcbf Lunr bootstrap.php third-party/slevomat/
```

## phpcs-sniffs [\<standard\>] [\<bootstrap file\>] [\<installed_paths\>]

Print the list of Sniffs included in the defined coding standard. If no standard is
selected it will pick `/var/www/libs/lunr-coding-standard/Lunr/` by default. You can
set a different default with either a `LUNR_CODING_STANDARD` environment variable, or a
`default_coding_standard` just variable.

You can specify a `bootstrap file` and/or define custom `installed_paths` if your coding
standard needs them.

Examples:
```bash
# List the Sniffs in the "PSR12" standard
just phpcs-sniffs PSR12

# List the Sniffs in the "Lunr" standard, specify the bootstrap file to use and with installed_paths to set
just phpcs-sniffs Lunr bootstrap.php third-party/slevomat/
```

## phpstan [\<level\>] [\<error_format\>]

Run `phpstan` to statically analyze the code. You can pass the phpstan level you want to
check for as an argument. If no default level is found it will assume level `0`.

Examples:
```bash
# Run phpstan and use whatever level is configured as the default
just phpstan

# Run phpstan with level 10
just phpstan 10

# Run phpstan with level 10 and set the output format as "prettyJson"
just phpstan 10 prettyJson
```

## phpunit [\<testsuite\>]

Run `phpunit` to execute the unit tests. You can optionally pass the name of a testsuite to only
run tests included in that testsuite.

The recipe will automatically pass `--log-junit=build/logs/junit.xml --coverage-clover=build/logs/clover.xml`
to phpunit if it detects that it's run from GitHub Actions.

Examples:
```bash
# Run all unit tests
just phpunit

# Run all unit tests in the 'Example' testsuite
just phpunit Example
```

## release-notes [\<base\>]

Generate release notes based on the git commit log. You can pass a tag name, branch name or commit
hash to generate release notes for all changes since then. By default it will take the latest tag.

The recipe expects the first line of the git commit message to follow a specific format:
```
(General|CI|Database|<component>): <message>
```

Release notes are then generated in this order:
1) General (global changes, dependency updates, etc)
2) CI (Changes related to CI workflows, phpunit/phpstan/phpcs fixes, etc)
3) Database (Changes to the database schema/migrations)
4) Remaining changes grouped alphabetically by the '\<component\>' specified in the commit message

Examples
```bash
# Generate release notes for all changes since the last tag
just release-notes

# Generate release notes for all changes since tag '1.0.0'
just release-notes 1.0.0
```

## reuse-lint

Check conformance to `REUSE` with [reuse-tool](https://github.com/fsfe/reuse-tool)

Examples:
```bash
# Check conformance to REUSE
just reuse-lint
```

## sqlfluff [\<paths\>] [\<dialect\>]

Analyze SQL code with [sqlfluff](https://www.sqlfluff.com/).

You can specify the path where sqlfluff should look for files. By default this is `tests/statics/sql`.
You can set a different default path by setting a `SQLFLUFF_PATHS` environment variable or a
`sqlfluff_paths` just variable.

You can also specify the dialect sqlfluff should use to parse the SQL code. By default this is `mariadb`.
You can set a different default dialect by setting a `SQLFLUFF_DIALECT` environment variable or a
`sqlfluff_dialect` just variable.

The recipe will automatically pass `--disable-progress-bar` to sqlfluff if it detects that it's
run from GitHub Actions.

Examples:
```bash
# Check test statics against the 'mariadb' dialect
just sqlfluff tests/statics/sql

# Check migrations against the 'sqlite' dialect
just sqlfluff docs/database/updates sqlite
```

## sqlfluff-fix [\<paths\>] [\<dialect\>]

Analyze SQL code with [sqlfluff](https://www.sqlfluff.com/) and automatically fix issues.

You can specify the path where sqlfluff should look for files. By default this is `tests/statics/sql`.
You can set a different default path by setting a `SQLFLUFF_PATHS` environment variable or a
`sqlfluff_paths` just variable.

You can also specify the dialect sqlfluff should use to parse the SQL code. By default this is `mariadb`.
You can set a different default dialect by setting a `SQLFLUFF_DIALECT` environment variable or a
`sqlfluff_dialect` just variable.

The recipe will automatically pass `--disable-progress-bar` to sqlfluff if it detects that it's
run from GitHub Actions.

Examples:
```bash
# Check test statics against the 'mariadb' dialect and automatically fix issues
just sqlfluff-fix tests/statics/sql

# Check migrations against the 'sqlite' dialect and automatically fix issues
just sqlfluff-fix docs/database/updates sqlite
```

## typos

Check for spelling mistakes with [typos](https://github.com/crate-ci/typos/)

Examples:
```bash
# Check for spelling mistakes
just typos
```
