# Spassky #
A distributed web testing tool. We use it at the BBC for testing our web apps on a wide range of mobile devices.


![Spassky](https://github.com/BBC/spassky/raw/master/spassky.jpg)

# Installation #

```
gem install spassky
```

# Usage #

Start the server:

```
spassky server 9191
```

Connect some devices by browsing to http://localhost:9191/device/connect on the device. The device will stay in an idle meta refresh loop until it receives a test to run.

Check what devices are connected to the server:
spassky devices http://localhost:9191

Run a test:

```
spassky run html_test.html http://localhost:9191
```

Run a test with colour:

```
spassky run html_test.html http://localhost:9191 --colour
```

Run a directory that contains a test (the first .html file will be used as the test)

```
spassky run test_directory http://localhost:9191
```

## Why? ##
We need to run automated tests on a wide range of web-enabled devices with very mixed capabilities. Some of them have JavaScript, but in many cases it's not standard and buggy. That means web testing tools targeted at desktop browsers don't tend to work very well, if at all. Spassky uses legacy techniques and as little client-side JavaScript as possible to ensure we can run tests on as many devices as possible.

## How it works ##
Physical devices act as test agents, connected permanently to a central server using meta refresh tags. Using a command-line utility, developers execute tests against those browsers by posting to the central server. The tests themselves are plain HTML pages, that are expected to call an assert URL (e.g. by embedding an image) within a time frame. That means even devices without any JavaScript can run automated tests of some kind.

## Some features that would be nice to have ##
- Assertions on network activity (e.g. for caching tests)