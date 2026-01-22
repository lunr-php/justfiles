# SPDX-FileCopyrightText: Copyright 2025 Move Agency Group B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

import 'clean.justfile'

github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))

phpunit testsuite='': (clean_log 'clover.xml') (clean_log 'junit.xml') (clean_dir 'coverage')
    #!/usr/bin/env bash

    REPO_ROOT=$(git rev-parse --show-toplevel)

    args=""

    if [ -x "${REPO_ROOT}/vendor/bin/phpunit" ]; then
      PHPUNIT="${REPO_ROOT}/vendor/bin/phpunit"
    else
      PHPUNIT_VERSION=""
      PHPUNIT_MAJOR_VERSION=""

      if [ -e "tests/phpunit.xml" ]; then
        PHPUNIT_VERSION=$(grep schema tests/phpunit.xml | cut -d "/" -f 4)
        PHPUNIT_MAJOR_VERSION=$(grep schema tests/phpunit.xml | cut -d "/" -f 4 | cut -d "." -f 1)
      fi

      if ! [ -z $(which "phpunit$PHPUNIT_VERSION" 2> /dev/null) ]; then
        PHPUNIT="phpunit${PHPUNIT_VERSION}"
      elif ! [ -z $(which "phpunit$PHPUNIT_MAJOR_VERSION" 2> /dev/null) ]; then
        PHPUNIT="phpunit${PHPUNIT_MAJOR_VERSION}"
      else
        PHPUNIT="phpunit"
      fi
    fi

    if [ -e "tests/phpunit.xml" ]; then
      args="$args -c tests/phpunit.xml"
    fi

    if [ "{{github_actions}}" != "0" ]; then
      args="$args --log-junit=build/logs/junit.xml --coverage-clover=build/logs/clover.xml"
    fi

    if ! [ "{{testsuite}}" = "" ]; then
      args="$args --testsuite {{testsuite}}"
    fi

    "${PHPUNIT}" $args
