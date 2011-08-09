Feature: Test Run
  
  In order to inform design decisions
  As a mobile tester
  I want to collate test results from multiple devices

  Background: A passing test
    Given a file named "passing.html" with:
      """
        <html>
          <head>
          </head>
          <body>
          <h1>My first passing test!</h1>
          <script type="text/javascript">
          assert(true, 'this test should pass');
          </script>
          </body>
        </html>
      """

  Scenario: One passing test on one device
    Given a connected mobile device "ipad"
    When I run "spassky <host> passing.html" with the server host 
    Then the output should contain:
      """
      1 test passed on 1 device
      """

  Scenario: One passing test on two devices
    Given a connected mobile device "first"
    And a connected mobile device "second"
    When I run "spassky <host> passing.html" with the server host 
    Then the output should contain:
      """
      1 test passed on 2 devices
      """