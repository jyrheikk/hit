# Manual Page for `hit`

## Name

`hit` &ndash; run HTTP Integration Tester (HIT) test scripts.

## Syntax

    hit [ ARGS ... ] [ [ -i FILE ] TEST ... ]

## Description

| Argument | Description |
| -------- | ----------- |
| -a, &#8209;&#8209;assertions | Reports the number of assertions instead of tests (ok/failed/skipped) |
| -d, &#8209;&#8209;dry-run | Lists all test suites, tests cases and URLs that _would_ be run; useful for verifying a test suite |
| -h, &#8209;&#8209;help | Shows this help for command-line arguments |
| -p, &#8209;&#8209;production | Tests only against the production environment (skip regression); when set, calls the custom function [`customIsProductionUrl`](CODING.md) to check which domain names belong to the production environment |
| -q, &#8209;&#8209;quiet | Quiet mode, does not show the progress with dots (`...`); useful for getting cleaner report when tests are run automatically |
| -r, &#8209;&#8209;regression | Runs regression tests only against non-production environments (skip production); when set, calls the custom function `customIsProductionUrl` to check which domain names do not belong to the production environment |
| -s, &#8209;&#8209;selftest | Runs the self-test, to verify that the HIT framework works |
| -t, &#8209;&#8209;trace | Traces errors, by printing the HTTP response headers of failed assertions; useful for troubleshooting |
| -u URL, &#8209;&#8209;url URL | Tests only the URLs that match the given `URL` pattern (substring, regular expression); useful for quickly running only selected tests |
| -w SEC, &#8209;&#8209;wait SEC | Wait time in seconds, used by the `doSleep` function (default `0.2`); used to avoid generating too much load on a server |
| -i FILE, &#8209;&#8209;input FILE | Gives the test data from the input file named `FILE` to the immediately following `TEST` script |
| TEST | One or more test scripts to be run; without them, the `test-*.sh` files in the current directory are run |

## Exit status

The number of failed test cases. `0` means OK, all tests passed.

## Environment

When the tests are run in the public Internet, unset the `http_proxy`
environment variable as follows:

    http_proxy= hit
