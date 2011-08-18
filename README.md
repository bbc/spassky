# Spassky #
A distributed web testing tool. We use it at the BBC for testing our web apps on a wide range of mobile devices.

## Why? ##
We need to run automated tests on a wide range of web-enabled devices with very mixed capabilities. Some of them have JavaScript, but in many cases it's not standard and buggy. That means web testing tools targeted at desktop browsers don't tend to work very well, if at all. Spassky uses legacy techniques and as little client-side JavaScript as possible to ensure we can run tests on as many devices as possible.

## How it works ##
Physical devices act as test agents, connected permanently to a central server using meta refresh tags. Using a command-line utility, developers execute tests against those browsers by posting to the central server. The tests themselves are plain HTML pages, that are expected to call an assert URL (e.g. by embedding an image) within a time frame. That means even devices without any JavaScript can run automated tests of some kind.

## Some features that would be nice to have ##
- Conveniently run QUnit / Jasmine / other tests
- Aliases for user agents
- Run tests on a subset of agents
- List disconnected devices
- Assertions on network activity (e.g. for caching tests)