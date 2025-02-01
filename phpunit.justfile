import 'clean.justfile'

github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))

phpunit testsuite='': (clean_log 'clover.xml') (clean_log 'junit.xml') (clean_dir 'coverage')
    #!/usr/bin/env bash
    args=""

    if [ -e "tests/phpunit.xml" ]; then
      args="$args -c tests/phpunit.xml"
    fi

    if [ "{{github_actions}}" = "1" ]; then
      args="$args --log-junit=build/logs/junit.xml --coverage-clover=build/logs/clover.xml"
    fi

    if ! [ "{{testsuite}}" = "" ]; then
      args="$args --testsuite {{testsuite}}"
    fi

    phpunit $args
