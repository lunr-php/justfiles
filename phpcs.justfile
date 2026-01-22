# SPDX-FileCopyrightText: Copyright 2025 Move Agency Group B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

import 'clean.justfile'

github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))
default_coding_standard := env('default_coding_standard', env('LUNR_CODING_STANDARD', '/var/www/libs/lunr-coding-standard/Lunr/'))

phpcs standard='<default>' bootstrap='bootstrap.php' installed_paths='third-party/slevomat/': (clean_log 'checkstyle.xml')
    #!/usr/bin/env bash

    REPO_ROOT=$(git rev-parse --show-toplevel)

    if [ -x "${REPO_ROOT}/vendor/bin/phpcs" ]; then
      PHPCS="${REPO_ROOT}/vendor/bin/phpcs"
    else
      PHPCS="phpcs"
    fi

    args=""

    if [ "{{standard}}" = "<default>" ]; then
      STANDARD="{{default_coding_standard}}"
    else
      STANDARD="{{standard}}"
    fi

    if [ "{{github_actions}}" != "0" ]; then
      args="$args --report-checkstyle=build/logs/checkstyle.xml"
    fi

    if [ -e "{{bootstrap}}" ]; then
      args="$args --bootstrap={{bootstrap}}"
    elif [ -e "$STANDARD/{{bootstrap}}"  ]; then
      args="$args --bootstrap=$STANDARD/{{bootstrap}}"
    elif [ -e "$(dirname $STANDARD)/{{bootstrap}}"  ]; then
      args="$args --bootstrap=$(dirname $STANDARD)/{{bootstrap}}"
    fi

    if [ -e "./{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath {{installed_paths}})"
    elif [ -e "$STANDARD/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath $STANDARD/{{installed_paths}})"
    elif [ -e "$(dirname $STANDARD)/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath $(dirname $STANDARD)/{{installed_paths}})"
    fi

    extra_files=$(git ls-files --cached --exclude-standard '*.php' | grep -vE '^config/locator/|^tests/statics/locator/|^src')

    "${PHPCS}" \
      -p \
      --report-full \
      --standard=$STANDARD \
      $args \
      $extra_files \
      src

phpcbf standard='<default>' bootstrap='bootstrap.php' installed_paths='third-party/slevomat/':
    #!/usr/bin/env bash

    REPO_ROOT=$(git rev-parse --show-toplevel)

    if [ -x "${REPO_ROOT}/vendor/bin/phpcbf" ]; then
      PHPCBF="${REPO_ROOT}/vendor/bin/phpcbf"
    else
      PHPCBF="phpcbf"
    fi

    args=""

    if [ "{{standard}}" = "<default>" ]; then
      STANDARD="{{default_coding_standard}}"
    else
      STANDARD="{{standard}}"
    fi

    if [ -e "{{bootstrap}}" ]; then
      args="$args --bootstrap={{bootstrap}}"
    elif [ -e "$STANDARD/{{bootstrap}}"  ]; then
      args="$args --bootstrap=$STANDARD/{{bootstrap}}"
    elif [ -e "$(dirname $STANDARD)/{{bootstrap}}"  ]; then
      args="$args --bootstrap=$(dirname $STANDARD)/{{bootstrap}}"
    fi

    if [ -e "./{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath {{installed_paths}})"
    elif [ -e "$STANDARD/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath $STANDARD/{{installed_paths}})"
    elif [ -e "$(dirname $STANDARD)/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath $(dirname $STANDARD)/{{installed_paths}})"
    fi

    extra_files=$(git ls-files --cached --exclude-standard '*.php' | grep -vE '^config/locator/|^tests/statics/locator/|^src/')

    "${PHPCBF}" \
      -p \
      --standard=$STANDARD \
      $args \
      $extra_files \
      src

phpcs-sniffs standard='<default>' bootstrap='bootstrap.php' installed_paths='third-party/slevomat/':
    #!/usr/bin/env bash

    REPO_ROOT=$(git rev-parse --show-toplevel)

    if [ -x "${REPO_ROOT}/vendor/bin/phpcs" ]; then
      PHPCS="${REPO_ROOT}/vendor/bin/phpcs"
    else
      PHPCS="phpcs"
    fi

    args=""

    if [ "{{standard}}" = "<default>" ]; then
      STANDARD="{{default_coding_standard}}"
    else
      STANDARD="{{standard}}"
    fi

    if [ -e "{{bootstrap}}" ]; then
      args="$args --bootstrap={{bootstrap}}"
    elif [ -e "$STANDARD/{{bootstrap}}"  ]; then
      args="$args --bootstrap=$STANDARD/{{bootstrap}}"
    elif [ -e "$(dirname $STANDARD)/{{bootstrap}}"  ]; then
      args="$args --bootstrap=$(dirname $STANDARD)/{{bootstrap}}"
    fi

    if [ -e "./{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath {{installed_paths}})"
    elif [ -e "$STANDARD/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath $STANDARD/{{installed_paths}})"
    elif [ -e "$(dirname $STANDARD)/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath $(dirname $STANDARD)/{{installed_paths}})"
    fi

    ${PHPCS} \
      --standard=$STANDARD \
      $args \
      -e
