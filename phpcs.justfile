# SPDX-FileCopyrightText: Copyright 2025 Move Agency Group B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

import 'clean.justfile'

github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))
default_coding_standard := env('default_coding_standard', env('LUNR_CODING_STANDARD', '/var/www/libs/lunr-coding-standard/Lunr/'))

phpcs standard='<default>' bootstrap='bootstrap.php' installed_paths='third-party/slevomat/': (clean_log 'checkstyle.xml')
    #!/usr/bin/env bash
    args=""

    if [ "{{standard}}" = "<default>" ]; then
      STANDARD="{{default_coding_standard}}"
    else
      STANDARD="{{standard}}"
    fi

    if [ "{{github_actions}}" = "1" ]; then
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

    phpcs \
      -p \
      --report-full \
      --standard=$STANDARD \
      $args \
      src

phpcbf standard='<default>' bootstrap='bootstrap.php' installed_paths='third-party/slevomat/':
    #!/usr/bin/env bash
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

    phpcbf \
      -p \
      --standard=$STANDARD \
      $args \
      src
