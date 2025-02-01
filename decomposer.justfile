decomposer type='dev':
    #!/usr/bin/env bash
    if [ "{{type}}" = "release" ]; then
      args="--no-dev"
    else
      args=""
    fi
    decomposer install $args
