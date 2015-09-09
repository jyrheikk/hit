#!/bin/bash
# Report test results.

startTime=$(date +%s)

_doDebug() {
    if [ -n "$optDebugMode" ]; then
        echo "$1"
    fi
}

_updateTestCounts() {
    ((testCount++))
    case "$currTestFailed" in
        $TEST_FAILED)
            _reportResponse
            ((failedTestCount++))
            if [ -n "$(_tooManyErrors)" ]; then
                _reportFailure "FATAL: too many errors"
            fi
            ;;
        $TEST_SKIPPED)
            ((skippedTestCount++))
            ;;
    esac
}

_reportResponse() {
    if [[ -n "$optTrace" && -n "$currentUrl" && -s "$req_responseHeaders" ]]; then
        echo "------------------------------------------------------------
HTTP response headers of <$currentUrl>:
"
        cat "$req_responseHeaders"
        echo "------------------------------------------------------------"
    fi
}

_reportTime() {
    # TODO: use milliseconds (date +%s%N) in Bash 4.X
    local readonly endTime=$(date +%s)
    local readonly timeDiff=$((endTime - startTime))

    [ -z "$optQuietMode" ] && echo ""
    echo "Time: $timeDiff s"
}

_reportProgress() {
    if [ -z "$optQuietMode" ]; then
        if [ -z "$1" ]; then
            echo -n ".";
        else
            echo "$1";
        fi
    fi
}

_reportFailure() {
    local status="$2"
    [ -z "$status" ] && status="E"
    _reportProgress "$status"
    echo "$1" >&2
}

_reportTests() {
    if [ $failedTestCount -gt 0 ]; then
        if [ $skippedTestCount -gt 0 ]; then
            local readonly andSkipped=", Skipped: $skippedTestCount"
        fi
        echo "Tests run: $testCount, Failures: $failedTestCount$andSkipped"
    else
        echo "OK ($testCount tests$(_reportSkipped))"
    fi
    return $failedTestCount
}

_reportAssertions() {
    local readonly assertCount=$((assertOkCount + failedTestCount))
    echo "$assertOkCount assertions of $assertCount passed, $failedTestCount failed$(_reportSkipped)."
    return $failedTestCount
}

_reportSkipped() {
    if [ $skippedTestCount -gt 0 ]; then
        echo ", $skippedTestCount skipped"
    fi
}

_tooManyErrors() {
    local readonly MAX_ERRORS=10
    [[ $failedTestCount -ge $MAX_ERRORS ]] && echo 1
}

# utilities for handling the test status

readonly TEST_FAILED=1
readonly TEST_SKIPPED=2

_failTest() {
    currTestFailed="$TEST_FAILED"
}

_skipTest() {
    currTestFailed="$TEST_SKIPPED"
}

_increaseAssertCount() {
    ((assertOkCount++))
}

testCount=0
failedTestCount=0
skippedTestCount=0
assertOkCount=0
