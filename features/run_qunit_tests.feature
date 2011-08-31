Feature: Run QUnit Tests

  In order to inform design decisions
  As a QUnit user
  I want to test JavaScript code on different web browsers

  Scenario: One passing suite on one device
    Given a file named "qunit_passing/qunit_test/passing.js" with:
      """
      QUnit.done = function(result) {
        if (result.failed > 0) {
          assert(false, "qunit failed");
        } else {
          assert(true, "qunit passed");
        }
      };

      test("it passes", function() {
        ok(true, "it passed");
      });
      """
      And a file named "qunit_passing/qunit_test/qunit.js" with qunit.js in it
    And a file named "qunit_passing/qunit_test/suite.html" with:
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
    When I run "spassky <host> qunit_passing/qunit_test" with the server host
    Then the output should contain:
      """
      PASS qunit_test on blackberry
      """
    And the exit status should be 0

  Scenario: One failing suite on one device
    Given a file named "qunit_failing/qunit_test/failing.js" with:
      """
      QUnit.done = function(result) {
        if (result.failed > 0) {
          assert(false, "qunit failed");
        } else {
          assert(true, "qunit passed");
        }
      };

      test("it fails", function() {
        ok(false, "it failed");
      });
      """
    And a file named "qunit_failing/qunit_test/qunit.js" with qunit.js in it
    And a file named "qunit_failing/qunit_test/suite.html" with:
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
    When I run "spassky <host> qunit_failing/qunit_test" with the server host
    Then the output should contain:
      """
      FAIL qunit_test on blackberry
      """
    And the exit status should be 1
