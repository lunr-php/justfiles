# SPDX-FileCopyrightText: Copyright 2025 Move Agency Group B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

import 'clean.justfile'

github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))

phpunit testsuite='': (clean_log 'clover.xml') (clean_log 'junit.xml') (clean_dir 'coverage')
    #!/usr/bin/env bash

    args=""

    PHPUNIT_VERSION=""
    PHPUNIT_MAJOR_VERSION=""

    if [ -e "tests/phpunit.xml" ]; then
      PHPUNIT_VERSION=$(grep schema tests/phpunit.xml | cut -d "/" -f 4)
      PHPUNIT_MAJOR_VERSION=$(grep schema tests/phpunit.xml | cut -d "/" -f 4 | cut -d "." -f 1)
      args="$args -c tests/phpunit.xml"
    fi

    if [ "{{github_actions}}" != "0" ]; then
      args="$args --log-junit=build/logs/junit.xml --coverage-clover=build/logs/clover.xml"
    fi

    if ! [ "{{testsuite}}" = "" ]; then
      args="$args --testsuite {{testsuite}}"
    fi

    if ! [ -z $(which "phpunit$PHPUNIT_VERSION" 2> /dev/null) ]; then
      phpunit$PHPUNIT_VERSION $args
    elif ! [ -z $(which "phpunit$PHPUNIT_MAJOR_VERSION" 2> /dev/null) ]; then
      phpunit$PHPUNIT_MAJOR_VERSION $args
    else
      phpunit $args
    fi
