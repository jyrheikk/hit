#!/bin/bash
# Template for redirect test classes.

testSource_() {
    local readonly sourceUrl=$(getSourceUrl "$1")
    local readonly destination=$(getDestinationUrl "$1")

    if [ -z "$sourceUrl" ]; then
        skipAndWarn "Empty source URL for $destination"
        return
    fi

    httpHead "$sourceUrl"

    local readonly statusCode=$(getSourceStatus "$1")
    assertStatusCodeExpected "$statusCode"

    assertLocation "$destination"

    # avoid hitting the same server too often
    doSleep
}

testDestination_() {
    local readonly destination=$(getDestinationUrl "$1")
    if [ -z "$destination" ]; then
        return
    fi

    httpHead "$destination"

    local readonly statusCode=$(getDestinationStatus "$1")
    assertStatusCodeExpected "$statusCode"
}
