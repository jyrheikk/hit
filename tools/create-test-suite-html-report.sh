#!/bin/bash
# Report test cases in HTML.

main() {
    local readonly SCRIPT="$(readlink -f "$0")"
    local readonly SCRIPT_PATH="$(dirname "$SCRIPT")"

    local readonly HTTP_PROTOCOL="https?://"

    if [[ $(matchesRegExp "$1" "$HTTP_PROTOCOL") -eq 1 ]]; then
        local readonly sourceCodeUrl="$1"
        shift
    fi

    local readonly name="HTTP integration tests"
    echo "<title>$name</title>"
    echo "<h1>$name</h1>"

    "$SCRIPT_PATH"/create-test-suite-report.sh "$@" \
        | testSuiteName2Heading \
        | filename2Link "$sourceCodeUrl" \
        | description2Html \
        | testCaseName2Html \
        | fixHtml
}

matchesRegExp() {
    echo "$1" | egrep --count "$2"
}

testSuiteName2Heading() {
    sed "s#\(^[A-Za-z0-9_-]* test suite\$\)#<h2>\1</h2>#"
}

filename2Link() {
    local readonly sourceCodeUrl="$1"
    local readonly filename="\([^ ]*\.sh\)"

    if [ -z "$sourceCodeUrl" ]; then
        sed "s#^ *$filename\$#<b>\1</b>#"
    else
        sed "s#^ *$filename\$#<b><a href=\"$sourceCodeUrl\1\">\1</a></b>#"
    fi
}

description2Html() {
    sed "s#^ *\(Test.*\)#<p>\1</p><ul>#"
}

testCaseName2Html() {
    sed "s#^ *- \(.*\)#<li>\1</li>#"
}

fixHtml() {
    sed -e "s#<b>#</ul><b>#" \
        -e "s#<h2>#</ul><h2>#"
}

main "$@"
