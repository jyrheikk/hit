#!/bin/bash
# Test the test suite HTML report generation.

readonly TEST_SUITE_URL="http://version-control/test-suite/"

setUpBeforeClass() {
    runHitTool create-test-suite-html-report.sh "$TEST_SUITE_URL"
}

tearDownAfterClass() {
    removeTestResponseBody
}

XtestScriptName() {
    local readonly TEST_SCRIPT="test-suite-html-report.sh"
    assertBody "<b><a href=\"${TEST_SUITE_URL}${TEST_SCRIPT}\">$TEST_SCRIPT</a></b>"
}

testScriptDescription() {
    assertBody "<p>Test the test suite HTML report generation"
}

XtestTestCaseName() {
    assertBody "<li>TestCaseName()"
}
