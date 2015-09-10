#!/bin/bash
# Test the HIT test class templates.

testIFramesTemplate() {
    verifyTemplateDryRunOutput "iframes" "testMainPageContent" "testIFrameContent"
}

testIntegrationsTemplate() {
    verifyTemplateDryRunOutput "integrations" "testUrl"
}

testRedirectsTemplate() {
    verifyTemplateDryRunOutput "redirects" "testSource" "testDestination"
}

verifyTemplateDryRunOutput() {
    local readonly template="$1"
    local readonly testUrl="http://test.com/"

    local readonly output="$(hit --dry-run dry-run-template-$template.sh)"
    local readonly urlFound="$(echo "$output" | egrep -c "$testUrl")"
    assertTrue "$urlFound" "test URL of template-$template found"
    shift

    for functionName in $@; do 
        local readonly functionFound="$(echo "$output" | egrep -c "$functionName")"
        assertTrue "$functionFound" "test function $functionName of the template-$template found"
    done
}
