Feature: Run HTML Tests
  
  In order to inform design decisions
  As a mobile tester
  I want to collate test results from multiple devices

  Background: Two tests, one passes, one fails
    Given a file named "passing.html" with:
      """
        <html>
          <head>
          </head>
          <body>
          <h1>A PASSING test!</h1>
          <script type="text/javascript">
          assert(true, 'this test should pass');
          </script>
          </body>
        </html>
      """
    And a file named "failing.html" with:
      """
        <html>
          <head>
          </head>
          <body>
          <h1>A FAILING test!</h1>
          <script type="text/javascript">
          assert(false, 'this test should fail');
          </script>
          </body>
        </html>
      """

  Scenario: One passing test on one device
    Given a connected mobile device "blackberry"
    When I run "spassky <host> passing.html" with the server host 
    Then the output should contain:
      """
      PASS passing.html on blackberry
      """
    And the exit status should be 0

  Scenario: One passing test on two devices
    Given a connected mobile device "blackberry"
    And a connected mobile device "iphone"
    When I run "spassky <host> passing.html" with the server host 
    Then the output should contain:
      """
      PASS passing.html on blackberry
      """
    Then the output should contain:
      """
      PASS passing.html on iphone
      """
    Then the exit status should be 0

  Scenario: Failing test
    Given a connected mobile device "blackberry"
    When I run "spassky <host> failing.html" with the server host
    Then the output should contain:
      """
      FAIL failing.html on blackberry
      """
    And the exit status should be 1
