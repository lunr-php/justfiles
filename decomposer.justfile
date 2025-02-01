# SPDX-FileCopyrightText: Copyright 2025 Move Agency Group B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

decomposer type='dev':
    #!/usr/bin/env bash
    if [ "{{type}}" = "release" ]; then
      args="--no-dev"
    else
      args=""
    fi
    decomposer install $args
