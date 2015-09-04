#!/bin/bash

readonly testDataDir="testdata"

runHitTool() {
    local readonly SCRIPT="$1"
    shift

    local readonly DOC="$SCRIPT-$RANDOM.tmp"
    local readonly TOOLS_DIR="../tools"
    local readonly TESTS_DIR="../tests"

    cd "$TOOLS_DIR"
    $SCRIPT "$@" "$TESTS_DIR" > "$TESTS_DIR/$DOC"
    cd "$TESTS_DIR"

    setTestResponseBody "$DOC"
    removeFile "$DOC"
}

setTestResponseBody() {
    # do not report some random URL in failures
    _setCurrentUrl ""
    # hack to enable _hasResponseBody in http-request.sh
    responseBodyRequested=1
    cp "$1" "$req_responseBody"
}

removeTestResponseBody() {
    removeFile "$req_responseBody"
}

setTestResponseHeaders() {
    cp "$1" "$req_responseHeaders"
}

removeTestResponseHeaders() {
    removeFile "$req_responseHeaders"
}
