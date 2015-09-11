#!/bin/bash
# Test IFrame content.

testMainPageContent_() {
    local readonly url="$(parseCsv "$1" 1)"
    local readonly content="$(parseCsv "$1" 2 | getPlainUrl_)"

    httpGet "$url"
    assertStatusOk
    assertTypeHtml
    assertBody "$content"
}

getPlainUrl_() {
    sed -e "s#https*:##" -e "s#\?.*##"
}

testIFrameContent_() {
    local readonly url="$(parseCsv "$1" 2)"
    local readonly content="$(parseCsv "$1" 3)"

    httpGet "$url"
    assertStatusOk
    assertBody "$content"
}
