# SPDX-FileCopyrightText: Copyright 2025 Framna Netherlands B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

database_migration_dir := env('database_migration_dir', 'docs/database')

[private]
generate-release-notes-section-general:
    #!/usr/bin/env bash

    BASE_RELEASE=$(git describe --tags --abbrev=0)
    LOG=$(git log --oneline --no-merges ${BASE_RELEASE}..)

    echo "General:"

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
generate-release-notes-section-ci:
    #!/usr/bin/env bash

    BASE_RELEASE=$(git describe --tags --abbrev=0)
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
generate-release-notes-section-database:
    #!/usr/bin/env bash

    BASE_RELEASE=$(git describe --tags --abbrev=0)
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
generate-release-notes-section component='':
    #!/usr/bin/env bash

    BASE_RELEASE=$(git describe --tags --abbrev=0)
    LOG=$(git log --oneline --no-merges ${BASE_RELEASE}..)

    echo "{{component}}:"
    while read commit && ! [ -z "$commit" ]; do
      echo -n "- "
      echo "$commit" | cut -d " " -f 3-
    done <<< "$(echo "$LOG" | grep "{{component}}:")"
    echo ""

release-notes:
    #!/usr/bin/env bash

    BASE_RELEASE=$(git describe --tags --abbrev=0)
    LOG=$(git log --oneline --no-merges ${BASE_RELEASE}..)

    just generate-release-notes-section-general
    just generate-release-notes-section-ci

    if [ -e "{{database_migration_dir}}" ]; then
      just generate-release-notes-section-database
    fi

    COMPONENTS=$(echo "$LOG" | cut -d " " -f 2 | cut -d ":" -f 1 | sort | uniq)

    for i in $COMPONENTS; do
      if [ "$i" = "General" -o "$i" = "CI" -o "$i" = "Database" ]; then
        continue
      fi

      just generate-release-notes-section "$i"
    done
