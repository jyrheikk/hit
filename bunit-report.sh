#!/bin/bash
# Report test results.

startTime=$(date +%s)

doDebug() {
    if [ -n "$optDebugMode" ]; then
        echo "$1"
    fi
}

updateTestCounts() {
    ((testCount++))
    case "$currTestFailed" in
        $TEST_FAILED)
            reportResponse
            ((failedTestCount++))
            if [ -n "$(tooManyErrors)" ]; then
                reportFailure "FATAL: too many errors"
            fi
            ;;
        $TEST_SKIPPED)
            ((skippedTestCount++))
            ;;
    esac
}

reportResponse() {
    if [[ -n "$optTrace" && -n "$currentUrl" && -s "$req_responseHeaders" ]]; then
        echo "------------------------------------------------------------
HTTP response headers of <$currentUrl>:
"
        cat "$req_responseHeaders"
        echo "------------------------------------------------------------"
    fi
}

reportTime() {
    # TODO: use milliseconds (date +%s%N) in Bash 4.X
    local readonly endTime=$(date +%s)
    local readonly timeDiff=$((endTime - startTime))

    [ -z "$optQuietMode" ] && echo ""
    echo "Time: $timeDiff s"
}

reportProgress() {
    if [ -z "$optQuietMode" ]; then
        if [ -z "$1" ]; then
            echo -n ".";
        else
            echo "$1";
        fi
    fi
}

reportFailure() {
    local status="$2"
    [ -z "$status" ] && status="E"
    reportProgress "$status"
    echo "$1" >&2
}

reportTests() {
    if [ $failedTestCount -gt 0 ]; then
        if [ $skippedTestCount -gt 0 ]; then
            local readonly andSkipped=", Skipped: $skippedTestCount"
        fi
        echo "Tests run: $testCount, Failures: $failedTestCount$andSkipped"
    else
        echo "OK ($testCount tests$(reportSkipped))"
    fi
    return $failedTestCount
}

reportAssertions() {
    local readonly assertCount=$((assertOkCount + failedTestCount))
    echo "$assertOkCount assertions of $assertCount passed, $failedTestCount failed$(reportSkipped)."
    return $failedTestCount
}

reportSkipped() {
    if [ $skippedTestCount -gt 0 ]; then
        echo ", $skippedTestCount skipped"
    fi
}

tooManyErrors() {
    local readonly MAX_ERRORS=10
    [[ $failedTestCount -ge $MAX_ERRORS ]] && echo 1
}

# utilities for handling the test status

readonly TEST_FAILED=1
readonly TEST_SKIPPED=2

failTest() {
    currTestFailed="$TEST_FAILED"
}

skipTest() {
    currTestFailed="$TEST_SKIPPED"
}

increaseAssertCount() {
    ((assertOkCount++))
}

testCount=0
failedTestCount=0
skippedTestCount=0
assertOkCount=0
