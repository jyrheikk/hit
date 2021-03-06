#!/bin/bash
# Report test case names and descriptions in human-readable format.

main() {
    for DIR in "$@"; do
        if [ ! -d "$DIR" ]; then
            echo "Test case directory does not exist: $DIR" >&2
            exit 2
        fi
        testSuiteName "$DIR"
        formatReport "$DIR"
    done
}

testSuiteName() {
    echo
    echo "$1 test suite" | sed "s#.*/##"
}

formatReport() {
    local readonly prefixes="^(test|# Test)"

    egrep "$prefixes" "$1"/test*.sh \
        | cleanFunctionNames \
        | sed "s/:/@/" \
        | commonFormat
}

commonFormat() {
    local readonly SCRIPT="$(readlink -f "$0")"
    local readonly SCRIPT_PATH="$(dirname "$SCRIPT")"

    awk -F@ -f "$SCRIPT_PATH/test-suite-report.awk"
}

cleanFunctionNames() {
    tr -d "{#" | sed "s/:test/:/"
}

main "$@"
