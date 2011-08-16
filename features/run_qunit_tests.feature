Feature: Run QUnit Tests
  
  In order to inform design decisions
  As a QUnit user
  I want to test JavaScript code on different web browsers
  
  Background: Two tests, one passes, one fails
    Given a file named "passing.js" with:
      """
      test("should pass", function() {
        ok(true, "it passed!");
      });
      """
    And a file named "failing.js" with:
      """
      test("should fail", function() {
        ok(false, "it failed!");
      });
      """
  
  Scenario: One passing test on one device
    Given a connected mobile device "blackberry"
    When I run "spassky <host> passing.js" with the server host 
    Then the output should contain:
      """
      PASS passing.js on blackberry
      """
    And the exit status should be 0