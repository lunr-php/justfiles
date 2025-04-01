# SPDX-FileCopyrightText: Copyright 2025 Framna Netherlands B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: MIT

typos:
    #!/usr/bin/env bash

    if [ -e "typos.toml" ]; then
      CONFIG="-c typos.toml"
    elif [ -e "tests/typos.toml" ]; then
      CONFIG="-c tests/typos.toml"
    else
      CONFIG=""
    fi

    typos $CONFIG
