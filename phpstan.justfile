github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))

phpstan level='6':
    #!/usr/bin/env bash
    if [ "{{github_actions}}" = "1" ]; then
      github="--error-format=github"
    else
      github=""
    fi
    phpstan analyze src -l {{level}} -c tests/phpstan.neon.dist $github
