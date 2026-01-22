# SPDX-FileCopyrightText: Copyright 2025 Framna Netherlands B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

database_migration_dir := env('database_migration_dir', 'docs/database')

[private]
generate-dependency-changelog base:
    #!/usr/bin/env bash
    if ! [ -e decomposer.json -o -e composer.json ]; then
      # skip if we don't have a decomposer.json or composer.json file
      exit 0
    fi

    BASE_RELEASE="{{base}}"

    if git cat-file -e HEAD:composer.lock 2>/dev/null; then
      { git show $BASE_RELEASE:composer.lock; cat composer.lock; } | jq --slurp -r '
        def pkgs(i): (.packages + .packages-dev)
          | map({name: .name, version: .version, dev: (.dev | if . then true else false end)})
          | group_by(.dev)
          | map({dev: .[0].dev, data: map({(.name): .version}) | add})
          | from_entries;

        # pkgs[false] = prod, pkgs[true] = dev
        (.[0] | pkgs) as $old |
        (.[1] | pkgs) as $new |

        # helper function to format diffs
        def diff($a; $b; $type):
          [
            ($a | keys[] | select($b[.] == null) | "- Dropped " + $type + "dependency on " + . + " (" + $a[.] + ")"),
            ($b | keys[] | select($a[.] == null) | "- Added " + $type + "dependency on " + . + " (" + $b[.] + ")"),
            ($b | keys[] | select($a[.] != null and $a[.] != $b[.]) | "- Updated " + $type + "dependency " + . + " from " + $a[.] + " to " + $b[.])
          ] | .[];

        # prod dependencies
        diff($old["false"] // {}; $new["false"] // {}; "") +
        # dev dependencies
        diff($old["true"] // {}; $new["true"] // {}; "dev-only ")
        | .[]
      '
    elif [ -e decomposer.json ]; then
      { git show $BASE_RELEASE:decomposer.json; cat decomposer.json; } | jq --slurp -r '
        (.[0] | map_values(.version)) as $a |
        (.[1] | map_values(.version)) as $b |
        [
          ($a | keys[] | select($b[.] == null) | "- Dropped dependency on " + .),
          ($b | keys[] | select($a[.] == null) | "- Added dependency on " + . + " (" + $b[.] + ")"),
          ($b | keys[] | select($a[.] != null and $a[.] != $b[.]) | "- Updated to " + . + " " + $b[.])
        ] | .[]
      '
    else
      { git show $BASE_RELEASE:composer.json; cat composer.json; } | jq --slurp -r '
        def deps(i; type):
          (.[i][if type=="dev" then "require-dev" else "require" end] // {})
          | del(.php)
          | with_entries(select(.key | test("^ext-") | not));

        def diff(type):
          deps(0; type) as $a
          | deps(1; type) as $b
          | [
              ($a | keys[] | select($b[.] == null)
                | "- Dropped " + (if type=="dev" then "dev-only " else "" end) + "dependency on " + .),
              ($b | keys[] | select($a[.] == null)
                | "- Added " + (if type=="dev" then "dev-only " else "" end) + "dependency on " + . + " (" + $b[.] + ")"),
              ($b | keys[] | select($a[.] != null and $a[.] != $b[.])
                | "- Changed " + (if type=="dev" then "dev-only " else "" end) + "dependency constraint for " + . + " from " + $a[.] + " to " + $b[.])
            ] | .[];

        # produce both sections
        diff("prod"), diff("dev")
      '
    fi

[private]
generate-release-notes-section-general base:
    #!/usr/bin/env bash

    BASE_RELEASE="{{base}}"
    LOG=$(git log --oneline --no-merges ${BASE_RELEASE}..)

    echo "General:"

    just generate-dependency-changelog "$BASE_RELEASE"

    while read commit && ! [ -z "$commit" ]; do
      HASH=$(echo "$commit" | cut -d " " -f 1)

      # All names of files that were changed in this commit
      FILES=$(git diff-tree --no-commit-id --name-only -r "$HASH")

      # Ignore commits that only change files in .github
      if echo "$FILES" | grep -qv '^\.github/'; then
        echo -n "- "
        echo "$commit" | cut -d " " -f 3-
      fi
    done <<< "$(echo "$LOG" | grep "General:")"

    echo ""

[private]
generate-release-notes-section-ci base:
    #!/usr/bin/env bash

    BASE_RELEASE="{{base}}"
    LOG=$(git log --oneline --no-merges ${BASE_RELEASE}..)

    echo "CI:"

    while read commit && ! [ -z "$commit" ]; do
      HASH=$(echo "$commit" | cut -d " " -f 1)

      # All names of files that were changed in this commit
      FILES=$(git diff-tree --no-commit-id --name-only -r "$HASH")

      # List commits that only change files in .github
      if echo "$FILES" | grep -q '^\.github/'; then
        echo -n "- "
        echo "$commit" | cut -d " " -f 3-
      fi
    done <<< "$(echo "$LOG")"

    echo ""

[private]
generate-release-notes-section-database base:
    #!/usr/bin/env bash

    BASE_RELEASE="{{base}}"
    LOG=$(git log --oneline --no-merges ${BASE_RELEASE}..)

    echo "Database:"

    while read commit && ! [ -z "$commit" ]; do
      HASH=$(echo "$commit" | cut -d " " -f 1)

      # All names of files that were changed in this commit
      FILES=$(git diff-tree --no-commit-id --name-only -r "$HASH")

      # List commits that include changes to database migrations
      if echo "$FILES" | grep -q '^{{database_migration_dir}}/'; then
        echo -n "- "
        echo "$commit" | cut -d " " -f 3-
      fi
    done <<< "$(echo "$LOG")"

    echo ""

[private]
generate-release-notes-section base component='':
    #!/usr/bin/env bash

    BASE_RELEASE="{{base}}"
    LOG=$(git log --oneline --no-merges ${BASE_RELEASE}..)

    echo "{{component}}:"
    while read commit && ! [ -z "$commit" ]; do
      echo -n "- "
      echo "$commit" | cut -d " " -f 3-
    done <<< "$(echo "$LOG" | grep "{{component}}:")"
    echo ""

release-notes base='<default>':
    #!/usr/bin/env bash

    if [ "{{base}}" = "<default>" ]; then
      BASE_RELEASE=$(git describe --tags --abbrev=0 2>/dev/null)

      if [ "$?" = 128 ]; then
        # Fresh repo without any tags
        echo "General:"
        echo "- Initial release"

        exit 0
      fi
    else
      BASE_RELEASE="{{base}}"
    fi

    LOG=$(git log --oneline --no-merges ${BASE_RELEASE}..)

    just generate-release-notes-section-general "$BASE_RELEASE"
    just generate-release-notes-section-ci "$BASE_RELEASE"

    if [ -e "{{database_migration_dir}}" ]; then
      just generate-release-notes-section-database "$BASE_RELEASE"
    fi

    COMPONENTS=$(echo "$LOG" | cut -d " " -f 2 | cut -d ":" -f 1 | sort | uniq)

    for i in $COMPONENTS; do
      if [ "$i" = "General" -o "$i" = "CI" -o "$i" = "Database" ]; then
        continue
      fi

      just generate-release-notes-section "$BASE_RELEASE" "$i"
    done
