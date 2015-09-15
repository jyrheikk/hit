#!/bin/bash
# Test the Bash unit test framework using itself, of course.

setUpBeforeClass() {
    ((setUpBeforeClassCount++))
    tearDownAfterClassCount=0
}

setUp() {
    ((setUpCount++))
}

tearDown() {
    ((tearDownCount++))
}

tearDownAfterClass() {
    ((tearDownAfterClassCount++))
    # bad practice: asserts should be run only in test cases
    assertEquals 1 $setUpBeforeClassCount
    assertEquals $setUpCount $tearDownCount
    assertEquals 1 $tearDownAfterClassCount
}

testIsExecutable() {
    local readonly THIS_SCRIPT="test-bunit-runner.sh"
    [ "$(_isExecutable $THIS_SCRIPT)" ] || failAssert $THIS_SCRIPT
    assertInTestCase
}

testIsNotExecutable() {
    local readonly TEST_FILE="$testDataDir/response-body.html"
    _isExecutable "$TEST_FILE" && failAssert "$TEST_FILE"
    assertInTestCase
}

testIsFunction() {
    local readonly EXISTING="assertTrue"
    isFunction $EXISTING || failAssert $EXISTING
}

testIsNotFunction() {
    local readonly NON_EXISTING="someNonExistingFunction"
    isFunction $NON_EXISTING && failAssert $NON_EXISTING
}

assertInTestCase() {
    assertEquals 1 $setUpBeforeClassCount "setUpBeforeClassCount"
    assertEquals $setUpCount $((tearDownCount + 1)) "setUpCount == tearDownCount + 1"
    assertEquals 0 $tearDownAfterClassCount "tearDownAfterClassCount"
}

TESTCaseNot() {
    failAssert "invalid test case: TESTCaseNot"
}

_testCaseNot() {
    failAssert "invalid test case: _testCaseNot"
}
