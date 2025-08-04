# SPDX-FileCopyrightText: Copyright 2025 Move Agency Group B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

phpstan level='<default>' error_format='table':
    #!/usr/bin/env bash

    if [ -e "tests/phpstan.neon.dist" ]; then
      CONFIG="-c tests/phpstan.neon.dist"
    else
      CONFIG=""
    fi

    if [ -e "tests/phpstan.autoload.inc.php" ]; then
      AUTOLOAD="-a tests/phpstan.autoload.inc.php"
    else
      AUTOLOAD=""
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

    phpstan analyze $LEVEL --error-format={{error_format}} $CONFIG $AUTOLOAD
