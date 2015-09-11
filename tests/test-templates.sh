#!/bin/bash
# Test the HIT test class templates.

testIFramesTemplate() {
    verifyTemplateDryRunOutput "iframes" "testMainPageContent_" "testIFrameContent_"
}

testIntegrationsTemplate() {
    verifyTemplateDryRunOutput "integrations" "testUrl_"
}

testRedirectsTemplate() {
    verifyTemplateDryRunOutput "redirects" "testSource_" "testDestination_"
}

verifyTemplateDryRunOutput() {
    local readonly template="$1"
    local readonly testUrl="http://test.com/"

    local readonly output="$(hit "$HIT_ARG_DRY_RUN" dry-run-template-$template.sh)"
    local readonly urlFound="$(echo "$output" | egrep -c "$testUrl")"
    assertTrue "$urlFound" "test URL of template-$template found"
    shift

    for functionName in $@; do 
        local readonly functionFound="$(echo "$output" | egrep -c "$functionName")"
        assertTrue "$functionFound" "test function $functionName of the template-$template found"
    done
}
