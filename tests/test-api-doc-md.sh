#!/bin/bash
# Test the API doc generation in Markdown.

setUpBeforeClass() {
    runHitTool create-api-doc.sh md
}

tearDownAfterClass() {
    removeTestResponseBody
}

testHeading() {
    assertBody "## Set HTTP request"
    assertBody "## Basic assertions"
}

testFunction() {
    assertBody "\* \`setUserAgent\`"
    assertBody "\* \`assertContentType\`"
    assertBody "\* \`assertBody\`"
    assertBody "\* \`assertEquals\`"
    assertBody "\* \`parseCsv\`"
}

testFunctionParameters() {
    assertBody "  \* Parameters: CSV-formatted"
    assertBody "  \* Verify"
}
