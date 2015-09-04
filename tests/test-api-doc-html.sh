#!/bin/bash
# Test the API doc generation in HTML.

setUpBeforeClass() {
    runHitTool create-api-doc.sh
}

tearDownAfterClass() {
    removeTestResponseBody
}

testHeading() {
    assertBody "<h2>Set HTTP request"
    assertBody "<h2>Basic assertions"
}

testFunction() {
    assertBody "<li>setUserAgent"
    assertBody "<li>assertContentType"
    assertBody "<li>assertBody"
    assertBody "<li>assertEquals"
    assertBody "<li>parseCsv"
}

testFunctionParameters() {
    assertBody "<i>Parameters: CSV-formatted"
    assertBody "<i>Verify"
}
