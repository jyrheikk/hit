#!/bin/bash
# Test that the required GNU tools are available: bash, egrep, grep, sed.

paramTest=(
    "bash --version"
    "egrep -V"
    "grep -V"
    "sed --version"
)

testGnuTool() {
    local readonly isGnu=$($1 | grep -c GNU)
    assertTrue $((isGnu > 0)) "$1: not GNU tool"
}
