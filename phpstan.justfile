phpstan level='<default>' error_format='table':
    #!/usr/bin/env bash

    if [ -e "tests/phpstan.neon.dist" ]; then
      CONFIG="-c tests/phpstan.neon.dist"
    else
      CONFIG=""
    fi

    if [ "{{level}}" = "<default>" ]; then
      if [ -z "$CONFIG" ]; then
        LEVEL="-l 0"
      else
        LEVEL=""
      fi
    else
      LEVEL="-l {{level}}"
    fi

    phpstan analyze $LEVEL --error-format={{error_format}} $CONFIG
