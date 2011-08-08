@javascript
Feature: Test Run
  
  In order to inform design decisions
  As a mobile tester
  I want to collate test results from multiple devices

  Scenario: Connect a device
    Given a connected mobile device "ipad"
    Then it should wait for a test to run

  Scenario: One passing test on one device
    Given a connected mobile device "ipad"
    And a file named "passing.html" with:
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
    When I run "spassky <host> passing.html" with the server host 
    Then the output should contain:
      """
      1 test passed on 1 device
      """

    @wip
    Scenario: One passing test on two devices
      Given a connected mobile device "first"
      And a connected mobile device "second"
      And a file named "passing-failing.html" with:
        """
          <html>
            <head>
            </head>
            <body>
            <h1>My second passing test!</h1>
            <script type="text/javascript">
            assert(true, 'this test should pass');
            </script>
            </body>
          </html>
        """
      When I run "spassky <host> passing-failing.html" with the server host 
      Then the output should contain:
        """
        1 test passed on 2 devices
        """