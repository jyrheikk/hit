#!/bin/bash
# Test a common utility of parsing comma-separated values.

testParseCsvWithoutComma() {
    local readonly csv="first"
    assertEquals "$csv" "$(parseCsv "$csv" 1)"
    assertEquals "" "$(parseCsv "$csv" 2)"
}

testParseCsvTwoValues() {
    local readonly csv="a,b"
    assertEquals "a" "$(parseCsv "$csv" 1)"
    assertEquals "b" "$(parseCsv "$csv" 2)"
    assertEquals "" "$(parseCsv "$csv" 3)"
}

testParseCsvEmptyValues() {
    local readonly csv=",b, ,d"
    assertEquals "" "$(parseCsv "$csv" 1)"
    assertEquals "b" "$(parseCsv "$csv" 2)"
    assertEquals " " "$(parseCsv "$csv" 3)"
    assertEquals "d" "$(parseCsv "$csv" 4)"
    assertEquals "" "$(parseCsv "$csv" 5)"
}

testParseStatusDefault() {
    local readonly input="xxx,"
    local readonly status="$(getSourceStatus $input)"
    assertEquals "301" "$status"
}

testParseStatusGiven() {
    local readonly input="xxx,"
    local readonly status="$(getSourceStatus $input 401)"
    assertEquals "401" "$status"
}
