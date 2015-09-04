#!/bin/bash
# Report test cases in HTML.

main() {
    local readonly HTTP_PROTOCOL="https?://"

    if [[ $(matchesRegExp "$1" "$HTTP_PROTOCOL") -eq 1 ]]; then
        local readonly sourceCodeUrl="$1"
        shift
    fi

    local readonly name="HTTP integration tests"
    echo "<title>$name</title>"
    echo "<h1>$name</h1>"

    ./create-test-suite-report.sh "$@" \
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
    local readonly testSuiteDir="\.\.\/[ \.\/]*[^/]*\/"
    local readonly sourceCodeUrl="$1"

    if [ -z "$sourceCodeUrl" ]; then
        sed "s# *$testSuiteDir\(.*\)#<b>\1</b>#"
    else
        sed "s# *$testSuiteDir\(.*\)#<b><a href=\"$sourceCodeUrl\1\">\1</a></b>#"
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
