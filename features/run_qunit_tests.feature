Feature: Run QUnit Tests

  In order to inform design decisions
  As a QUnit user
  I want to test JavaScript code on different web browsers

  Background: Two tests, one passes, one fails
    Given a file named "qunit_suite/passing.js" with:
      """
      QUnit.done = function(failed, passed, total, runtime){
      assert(true, "pass");

        if (failed.length() > 0) {
          assert(false, "qunit failed");
        } else {
          assert(true, "qunit passed");
        }
      };

      test("should pass", function() {
        ok(true, "it passed!");
      });
      """
    And a file named "qunit_suite/qunit.js" with QUnit.js in it
    And a file named "qunit_suite/suite.html" with:
      """
      <html>
        <head>
        </head>
        <body>
        <h1>A QUnit Suite</h1>
        <script type="text/javascript" src="qunit.js"></script>
        <script type="text/javascript" src="passing.js"></script>
        </body>
      </html>
      """

  @wip
  Scenario: One passing suite on one device
    Given a connected mobile device "blackberry"
    When I run "spassky <host> qunit_suite" with the server host
    Then the output should contain:
      """
      PASS qunit_suite on blackberry
      """
    And the exit status should be 0
