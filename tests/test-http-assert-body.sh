#!/bin/bash
# Test HTTP assert body functions.

setUpBeforeClass() {
    setTestResponseBody "$testDataDir/response-body.html"
}

tearDownAfterClass() {
    removeTestResponseBody
}

testBody() {
    assertBody "This is title"
    assertBody "<p>This is paragraph</p>"
    assertBodyNot "href"
    assertBodyNoJavaScript
}
