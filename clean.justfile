# SPDX-FileCopyrightText: Copyright 2025 Move Agency Group B.V., Zwolle, The Netherlands
# SPDX-License-Identifier: CC0-1.0

@clean:
    rm -rf tmp
    rm -rf build

[private]
@clean_log file:
    mkdir -p build/logs
    rm -f build/logs/{{file}}

[private]
@clean_dir directory:
    mkdir -p build/{{directory}}
    rm -rf build/{{directory}}/*
