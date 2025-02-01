clean:
    rm -rf tmp
    rm -rf build

[private]
clean_log file:
    mkdir -p build/logs
    rm -f build/logs/{{file}}

[private]
clean_dir directory:
    mkdir -p build/{{directory}}
    rm -rf build/{{directory}}/*
