import 'clean.justfile'

github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))

phpcs standard='../lunr-coding-standard/Lunr' bootstrap='bootstrap.php' installed_paths='third-party/slevomat/': (clean_log 'checkstyle.xml')
    #!/usr/bin/env bash
    args=""

    if [ "{{github_actions}}" = "1" ]; then
      args="$args --report-checkstyle=build/logs/checkstyle.xml"
    fi

    if [ -e "{{bootstrap}}" ]; then
      args="$args --bootstrap={{bootstrap}}"
    elif [ -e "{{standard}}/{{bootstrap}}"  ]; then
      args="$args --bootstrap={{standard}}/{{bootstrap}}"
    elif [ -e "$(dirname {{standard}})/{{bootstrap}}"  ]; then
      args="$args --bootstrap=$(dirname {{standard}})/{{bootstrap}}"
    fi

    if [ -e "./{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath {{installed_paths}})"
    elif [ -e "{{standard}}/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath {{standard}}/{{installed_paths}})"
    elif [ -e "$(dirname {{standard}})/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath $(dirname {{standard}})/{{installed_paths}})"
    fi

    phpcs \
      -p \
      --report-full \
      --standard={{standard}} \
      $args \
      src

phpcbf standard='../lunr-coding-standard/Lunr' bootstrap='bootstrap.php' installed_paths='third-party/slevomat/':
    #!/usr/bin/env bash
    args=""

    if [ -e "{{bootstrap}}" ]; then
      args="$args --bootstrap={{bootstrap}}"
    elif [ -e "{{standard}}/{{bootstrap}}"  ]; then
      args="$args --bootstrap={{standard}}/{{bootstrap}}"
    elif [ -e "$(dirname {{standard}})/{{bootstrap}}"  ]; then
      args="$args --bootstrap=$(dirname {{standard}})/{{bootstrap}}"
    fi

    if [ -e "./{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath {{installed_paths}})"
    elif [ -e "{{standard}}/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath {{standard}}/{{installed_paths}})"
    elif [ -e "$(dirname {{standard}})/{{installed_paths}}" ]; then
      args="$args --runtime-set installed_paths $(realpath $(dirname {{standard}})/{{installed_paths}})"
    fi

    phpcbf \
      -p \
      --standard={{standard}} \
      $args \
      src
