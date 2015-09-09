#!/bin/bash
# Test Cross Origin Resource Sharing (CORS) enabled.

testCors() {
    httpGet "http://www.html5rocks.com/en/"

    assertStatusOk
    assertCorsEnabled
}
