import 'clean.justfile'

github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))

phpunit testsuite='': (clean_log 'clover.xml') (clean_log 'junit.xml') (clean_dir 'coverage')
    #!/usr/bin/env bash
    if [ "{{github_actions}}" = "1" ]; then
      args="--log-junit=build/logs/junit.xml --coverage-clover=build/logs/clover.xml"
    else
      args=""
    fi
    if ! [ "{{testsuite}}" = "" ]; then
      args+="--testsuite {{testsuite}}"
    else
      args+=""
    fi
    phpunit -c tests/phpunit.xml $args
