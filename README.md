Spassky
=======
Spassky is a test framework that allows us to automate the process of running JavaScript Unit tests on various browsers and devices.
It currently supports running tests in QUnit, but in theory, will support any JavaScript framework that the browser supports.

Spassky was a protagonist in the greatest Chess match of last century - which being played by an American and a Soviet Russian, was a Cold War metaphor. Spassky eventually resigned and Fischer won the championship.

Architecture
------------
```
                   +-----+
                   | You |
                   +--+--+
                      |
                      |
                      v
 +------------------------------------------+
 |         Spassky Central Server           |
 +------------------------------------------+
           |           |          |
           |           |          |
           v           v          v
       +-------+   +-------+   +-----+
       |iPhone3|   |iPhone4|   |Nokia|
       |-------|   |-------|   |-----|
       |       |   |       |   | +++ |
       |       |   |       |   | +++ |
       |   +   |   |   +   |   | +++ |
       +-------+   +-------+   +-----+
```

Developers push JS unit tests to the Spassky server through a command line interface.
Multiple devices connected to the central Spassky server will poll the server for a suite of tests.
The browser will be redirected to the test page, run the tests, and then are redirected to the idle loop.

Installation
------------

```
gem install spassky
```

![Spassky](https://github.com/BBC/spassky/raw/master/spassky.jpg)


Usage
-----

Start the server:

```
spassky server --port 9191
```

Connect test devices by browsing to http://localhost:9191/device/connect on the device. The device will stay in an idle meta refresh loop until it receives a test to run.

Check what devices are connected to the server:

```
spassky devices --server http://localhost:9191
```

Run a single html file (the second parameter is the test name):

```
spassky run --pattern html_test.html --test html_test.html --server http://localhost:9191
```

Run a test with colour:

```
spassky run --pattern html_test.html --test html_test.html --server http://localhost:9191 --colour
```

Run a directory that contains a test

```
spassky run --pattern test_directory --test html_test.html --server http://localhost:9191
```

Why?
----
We need to run automated tests on a wide range of web-enabled devices with very mixed capabilities. Some of them have JavaScript, but in many cases it's not standard and buggy. That means web testing tools targeted at desktop browsers don't tend to work very well, if at all. Spassky uses legacy techniques and as little client-side JavaScript as possible to ensure we can run tests on as many devices as possible.

How it works
------------
Physical devices act as test agents, connected permanently to a central server using meta refresh tags. Using a command-line utility, developers execute tests against those browsers by posting to the central server. The tests themselves are plain HTML pages, that are expected to call an assert URL (e.g. by embedding an image) within a time frame.

Test structure
--------------
Tests can be either a single html file, or a directory containing multiple files.

If spassky is given a directory, it will pass all files in that directory to that server. Any other files in the test directory can be linked to from the html file relatively.

### An example test directory:
```
test_name
 |-scripts/main.js
 |-css/main.css
 |-test.html
```

Some features that would be nice to have
----------------------------------------
- Assertions on network activity (e.g. for caching tests)
