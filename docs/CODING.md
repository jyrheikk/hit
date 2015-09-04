# HIT Coding Guidelines

## Default settings

To minimise the amount of code in test cases, [HTTP Integration
Tester](/README.md) (HIT) runs `curl` with the following default
settings:

* HTTP proxy is read from the `http_proxy` environment variable. It is
  required for accessing servers outside the intranet.
* `connect-timeout` and `max-time` are both set to 30 seconds, to
  avoid failing or slow requests from hanging indefinitely.

Moreover, the following HTTP request headers are set by default for each request:

| Name | Value | Reason |
| ---- | ----- | ------ |
| `Accept-Encoding` | `gzip, deflate` | Allow compressed resources, to improve performance |
| `Accept` | `*/*` | Avoid Web Application Firewalls or ModSecurity from blocking requests |
| `Host` | URL domain | Same |
| `User-Agent` | `HIT Tester` | Same |
| `Cache-Control` | `no-cache` | Avoid proxy servers and Akamai from returning cached resources |
| `Pragma` | `no-cache` | Same |

## Custom functions

A test class can implement the following callback functions that are
called by the test runner and take a URL as a parameter:

| Name | Description |
| ---- | ----------- |
| `customIsIntranetUrl` | Returns 0 (OK) if the given URL is not accessible outside the intranet. When tests are run outside the intranet (`http_proxy` undefined), a test that tries to access a non-accessible URL gives only a warning instead of failing the test. |
| `customIsProductionUrl` | Returns 0 (OK) if the given URL is in the production environment; with the `--production` argument, HIT skips the (regression) tests run against non-production environments. |
| `customSetDomainHeaders` | Sets HTTP request headers needed by the domain; e.g., credentials for access-controlled domains. |

Examples:

    customIsProductionUrl() {
        local readonly host="$(getHostOfUrl $1)"

        if [ "$host" != "prod.mydomain.com" ]; then
            return 1
        fi
    }

    customSetDomainHeaders() {
        local readonly host="$(getHostOfUrl $1)"

        if [ "$host" == "test.mydomain.com" ]; then
            setCredentials "myusername:mypassword"
        fi
    }

Before running a test suite, HIT includes its `common*.sh` files,
which may contain **common constants and reusable functions**; e.g.,
the custom functions described above.

## Coding HIT tests

* Read the [HIT API documentation](API.md).
* Let the HIT framework run the show.
  * Do not call the `test`, `setUp` or `tearDown` functions explicitly.
* Use assertions only in the `test` functions.
  * But not in `setUp` or `tearDown`.
* Avoid common [unit test
  antipatterns](http://www.exubero.com/junit/antipatterns.html), such
  as Redundant Assertions and Only Happy Path Tests.
* Don't Repeat Yourself (DRY). Instead of copy-pasting, encapsulate
  common code in reusable functions and put them in the `common*.sh` files.
* Use the HIT [test class templates](TEMPLATES.md).

## Code formatting

* The 1st line of each script should be a
  [hashbang](http://en.wikipedia.org/wiki/Shebang_%28Unix%29).
* The 2nd line of each script should be a one-liner comment that
  briefly describes the test class.
* Indent code consistently with 4 spaces. Do not use tab characters anywhere.
* Declare functions as `functionName()`, without the redundant `function`.
* Define variables inside a function as `local`. Otherwise they might
  clash with other global variables.
* Define constants as `readonly`, to avoid accidentally changing their
  value. It also documents the purpose of the variable.
* Add quotation marks around strings and variables. Otherwise a
  variable whose value has a space would be regarded as two separate
  arguments.

Gotcha. Complex `if` conditions (AND, OR) require double square brackets:

    if [[ -n "$host" && -z "$error" ]]; then

## References

* Follow the Google [Shell Style Guide](https://google-styleguide.googlecode.com/svn/trunk/shell.xml).
* [Bash programming reference](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html) (first 8 chapters are relevant).
* Learn [Hypertext Transfer Protocol HTTP/1.1](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html).
