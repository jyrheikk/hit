# HTTP Integration Tester (HIT)

HIT is a testing framework that

* Enables writing **compact and readable**, yet powerful **test cases**.
* **Verifies architectural properties** (availability, performance,
security) of a **web system**.
* Is implemented in Bash, in the spirit of xUnit test frameworks.

HIT

* Sends HTTP requests using `curl`, which writes the HTTP response body and headers into two files.
* Checks the HTTP response headers and body using `grep`.
* Provides reusable test cases as [test class templates](/docs/TEMPLATES.md).
* Has a comprehensive set of unit tests (run with the `--selftest` argument).

## Features

| HIT verifies | Checking HTTP | Examples |
| ------------ | ------------- | -------- |
| Availability, system integration | Status code | Expect 200 (OK), or 301/302 (Moved) from HTTP redirects |
| Performance | Response headers | Cacheability (`Cache-Control`), compressed body (`Content-Encoding`) |
| Security | Response headers | Clickjacking disallowed (`X-Frame-Options`), server version number not revealed (`Server`) |
| API methods | Response body | The existence of a piece of content (e.g., HTML, JSON) can be verified |
| Usability | Response body | Search Engine Optimization (e.g., the `title` and `meta` HTML tags) |

HIT can be used both in the production and testing environments for

* Monitoring system availability (of critical services and resources)
* Scanning security vulnerabilities (verifying the implemented security controls)
* Testing the regression of system configuration settings

The following tests are **outside the scope** of HIT:

* Functional testing that requires web browser functionality (HTML rendering, JavaScript engine etc.).
* Content validation (no support for HTML parsing).
* Unit testing (except that of Bash scripts: HIT is naturally tested by itself).

## Terminology

| Term | Description |
| ---- | ----------- |
| Test case | Bash function named `test*` that sends an HTTP request, and verifies the response with calls to `assert` functions |
| Test class | Bash script named `test-*` that contains related test cases, and optionally the `setUp` and `tearDown` functions |
| Test class template | Bash script located in `hit/templates` that contains reusable test cases to be imported in a test class |
| Parameterized test class | Test class that defines the `paramTest` variable whose value is either an array or a file that contains test parameters; the test cases of the test class are invoked once per each parameter (array element or file row) |
| Test suite | File directory that contains related test classes |
| Test runner | Bash script named `hit` that runs the test cases in the given test classes |

## How test cases are executed

Each Bash function whose name starts with `test` is regarded as a test case. Note that the test cases are not run in the same order as they are defined in the test script.

![HIT sequence diagram](/docs/hit-sequence.png)

(Created by [WebSequenceDiagrams.com](http://websequencediagrams.com/)
using the [source data](/docs/hit-sequence.txt).)

## Sample test case

The test cases use the [HIT API](/docs/API.md), which contains

* `set` functions for HTTP request headers.
* `assert` functions for HTTP response headers and body.
* Utility functions for parsing strings.

Example of a test case class that tests the HTTP response headers of
the GitHub home page:

    #!/bin/bash

    testGitHubHome() {
        httpGet "https://github.com/"

        assertStatusOk
        assertTypeHtml
        assertCacheControlNoCache
        assertCompressed
        assertBody "GitHub"
    }

## Installing HIT

Clone the Git repository, and verify that you have the tools required by HIT:

* GNU tools `bash`, `egrep`, `grep`, `sed`.
* Commands `awk`, `cat`, `cut`, `tr`.
* [`curl`](http://curl.haxx.se/) for URL transfer.

Before running `hit`, set the following environment variables in the
`.bash_profile` file of your home directory:

    export PATH="$PATH:/<git-root>/hit"
    # required if accessing servers outside the intranet
    export http_proxy=http://<my-proxy-domain>:<my-proxy-port>

Verify that HIT works, by running the self-test:

    $ hit -s
    ..................................................................................................
    Time: 1 s
    OK (98 tests)

## Running test cases

See help for the command-line arguments:

    $ hit -h

Without parameters, `hit` runs all the tests (named as `test-*.sh`) in
the current directory. Run one test as follows:

    $ cd tests
    $ hit test-gnu-tools.sh

When testing outside the intranet, either unset the `http_proxy`
environment variable, or disable it as follows:

    $ http_proxy= hit

Read the [HIT coding guidelines](/docs/CODING.md) when you start
developing your own HIT tests.
