# SPDX-FileCopyrightText: Copyright 2025 Framna Netherlands B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

sqlfluff_dialect := env('sqlfluff_dialect', env('SQLFLUFF_DIALECT', 'mariadb'))
sqlfluff_paths := env('sqlfluff_paths', env('SQLFLUFF_PATHS', 'tests/statics/sql'))
github_actions := env('github_actions', env('GITHUB_ACTIONS', '0'))

sqlfluff paths='<default>' dialect='<default>':
    #!/usr/bin/env bash
    args=""

    if [ "{{dialect}}" = "<default>" ]; then
      DIALECT="{{sqlfluff_dialect}}"
    else
      DIALECT="{{dialect}}"
    fi

    if [ "{{paths}}" = "<default>" ]; then
      PATHS="{{sqlfluff_paths}}"
    else
      PATHS="{{paths}}"
    fi

    if [ "{{github_actions}}" != "0" ]; then
      args="$args --disable-progress-bar"
    fi

    sqlfluff \
      lint \
      --dialect=$DIALECT \
      --warn-unused-ignores \
      $args \
      $PATHS

sqlfluff-fix paths='<default>' dialect='<default>':
    #!/usr/bin/env bash
    args=""

    if [ "{{dialect}}" = "<default>" ]; then
      DIALECT="{{sqlfluff_dialect}}"
    else
      DIALECT="{{dialect}}"
    fi

    if [ "{{paths}}" = "<default>" ]; then
      PATHS="{{sqlfluff_paths}}"
    else
      PATHS="{{paths}}"
    fi

    if [ "{{github_actions}}" != "0" ]; then
      args="$args --disable-progress-bar"
    fi

    sqlfluff \
      fix \
      --dialect=$DIALECT \
      $args \
      $PATHS
