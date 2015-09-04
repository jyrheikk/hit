#!/bin/bash
# Test HTTP response headers of the GitHub home page.

testGitHubHome() {
    httpGet "https://github.com/"

    assertStatusOk
    assertTypeHtml
    assertCacheControlNoCache
    assertCompressed
    assertBody "GitHub"
}
