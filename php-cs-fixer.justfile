# SPDX-FileCopyrightText: Copyright 2026 Framna Netherlands B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

import 'clean.justfile'

github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))
php_cs_fixer_ruleset := env('php_cs_fixer_ruleset', env('PHP_CS_FIXER_RULESET', ".php-cs-fixer.php"))

php-cs-fixer: (clean_log 'php-cs-fixer-checkstyle.xml')
    #!/usr/bin/env bash

    REPO_ROOT=$(git rev-parse --show-toplevel)

    if [ -x "${REPO_ROOT}/vendor/bin/php-cs-fixer" ]; then
      PHPCSFIXER="${REPO_ROOT}/vendor/bin/php-cs-fixer"
    else
      PHPCSFIXER="php-cs-fixer"
    fi

    if [ -e "{{php_cs_fixer_ruleset}}" ]; then
      args="--config={{php_cs_fixer_ruleset}}"
    else
      args=""
    fi

    args="$args --cache-file=build/.php-cs-fixer.cache"
    files=$(git ls-files --cached --exclude-standard '*.php' | grep -vE '^config/locator/|^tests/statics/locator/|^src|^tests/unit/')
    files="src tests/unit $files"

    if [ "{{github_actions}}" != "0" ]; then
      $PHPCSFIXER \
        check \
        --format=checkstyle \
        $args \
        $files \
        2>/dev/null \
        1>build/logs/php-cs-fixer-checkstyle.xml
    fi

    $PHPCSFIXER \
      check \
      --verbose \
      --diff \
      $args \
      $files
