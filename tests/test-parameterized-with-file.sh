#!/bin/bash
# Test parameterized test cases: spaces allowed in values read from a file.

paramTest="$testDataDir/param.csv"

testStringCase() {
    local readonly toSmall="$(parseCsv "$1" 1 | tr '[:upper:]' '[:lower:]')"
    local readonly lower="$(parseCsv "$1" 2)"

    assertEquals "$lower" "$toSmall"
}
