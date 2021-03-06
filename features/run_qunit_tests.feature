Feature: Run QUnit Tests

  In order to inform design decisions
  As a QUnit user
  I want to test JavaScript code on different web browsers

  Scenario: One passing suite on one device
    Given a file named "qunit_passing/qunit_test/passing.js" with:
      """
      QUnit.done = function(result) {
        var spassky = new Spassky();
        if (result.failed > 0) {
          spassky.assert(false, "qunit failed");
        } else {
          spassky.assert(true, "qunit passed");
        }
      };

      test("it passes", function() {
        ok(true, "it passed");
      });
      """
    And a file named "qunit_passing/qunit_test/qunit.js" with qunit.js in it
    And a file named "qunit_passing/qunit_test/test_suite.html" with:
      """
      <html>
        <head></head>
        <body>
          <h1>A QUnit Suite</h1>
          <script type="text/javascript" src="qunit.js"></script>
          <script type="text/javascript" src="passing.js"></script>
        </body>
      </html>
      """
    And a connected mobile device "blackberry"
    When I run "spassky run --pattern qunit_passing/qunit_test --test test_suite.html --server <host>" with the server host
    Then the output should contain:
      """
      PASS test_suite.html on blackberry
      """
    And the exit status should be 0

  Scenario: One failing suite on one device
    Given a file named "qunit_failing/qunit_test/failing.js" with:
      """
      QUnit.done = function(result) {
        var spassky = new Spassky();
        if (result.failed > 0) {
          spassky.assert(false, "qunit failed");
        } else {
          spassky.assert(true, "qunit passed");
        }
      };

      test("it fails", function() {
        ok(false, "it failed");
      });
      """
    And a file named "qunit_failing/qunit_test/qunit.js" with qunit.js in it
    And a file named "qunit_failing/qunit_test/test_suite.html" with:
      """
      <html>
        <head></head>
        <body>
          <h1>A QUnit Suite</h1>
          <script type="text/javascript" src="qunit.js"></script>
          <script type="text/javascript" src="failing.js"></script>
        </body>
      </html>
      """
    And a connected mobile device "blackberry"
    When I run "spassky run --pattern qunit_failing/qunit_test --test test_suite.html --server <host>" with the server host
    Then the output should contain:
      """
      FAIL test_suite.html on blackberry
      """
    And the exit status should be 1

  Scenario: Support multiple levels of recursion
    Given a file named "qunit_passing/qunit_test/another_directory/passing.js" with:
      """
      QUnit.done = function(result) {
        var spassky = new Spassky();
        if (result.failed > 0) {
          spassky.assert(false, "qunit failed");
        } else {
          spassky.assert(true, "qunit passed");
        }
      };

      test("it passes", function() {
        ok(true, "it passed");
      });
      """
    And a file named "qunit_passing/qunit_test/another_directory/qunit.js" with qunit.js in it
    And a file named "qunit_passing/qunit_test/test_suite.html" with:
      """
      <html>
        <head></head>
        <body>
          <h1>A QUnit Suite</h1>
          <script type="text/javascript" src="another_directory/qunit.js"></script>
          <script type="text/javascript" src="another_directory/passing.js"></script>
        </body>
      </html>
      """
    And a connected mobile device "blackberry"
    When I run "spassky run --pattern qunit_passing/qunit_test --test test_suite.html --server <host>" with the server host
    Then the output should contain:
      """
      PASS test_suite.html on blackberry
      """
    And the exit status should be 0

  Scenario: Test with a file in a relative path
    Given a file named "test/js/passing.js" with:
      """
      new Spassky().assert(true, "qunit passed");
      """
    And a file named "test/html/suite.html" with:
      """
      <html>
        <head></head>
        <body>
          <script type="text/javascript" src="../js/passing.js"></script>
        </body>
      </html>
      """
    And a connected mobile device "blackberry"
    When I run "spassky run --pattern test --test html/suite.html --server <host>" with the server host
    Then the output should contain:
      """
      PASS html/suite.html on blackberry
      """
    And the exit status should be 0
