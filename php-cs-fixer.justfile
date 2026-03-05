# SPDX-FileCopyrightText: Copyright 2026 Framna Netherlands B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

import 'clean.justfile'

github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))

php-cs-fixer: (clean_log 'php-cs-fixer-checkstyle.xml')
    #!/usr/bin/env bash

    REPO_ROOT=$(git rev-parse --show-toplevel)

    if [ -x "${REPO_ROOT}/vendor/bin/php-cs-fixer" ]; then
      PHPCSFIXER="${REPO_ROOT}/vendor/bin/php-cs-fixer"
    else
      PHPCSFIXER="php-cs-fixer"
    fi

    if [ "{{github_actions}}" != "0" ]; then
      $PHPCSFIXER \
        check \
        --format=checkstyle \
        2>/dev/null \
        1>build/logs/php-cs-fixer-checkstyle.xml
    fi

    $PHPCSFIXER \
      check \
      --verbose \
      --diff
