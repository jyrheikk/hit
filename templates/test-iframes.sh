#!/bin/bash
# Test IFrame content.

testMainPageContent() {
    local readonly url="$(parseCsv "$1" 1)"
    local readonly content="$(parseCsv "$1" 2 | getPlainUrl)"

    httpGet "$url"
    assertStatusOk
    assertTypeHtml
    assertBody "$content"
}

getPlainUrl() {
    sed -e "s#https*:##" -e "s#\?.*##"
}

testIFrameContent() {
    local readonly url="$(parseCsv "$1" 2)"
    local readonly content="$(parseCsv "$1" 3)"

    httpGet "$url"
    assertStatusOk
    assertBody "$content"
}
