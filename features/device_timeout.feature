Feature: Device Timeout
  In order for a clean test run
  As a Developer-in-Test
  I want to ignore devices that haven't connected recently
  
  Background: One passing test
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
      
  @wip
  Scenario: One device times out
    Given a connected mobile device
    When the device disconnects
    And I run "spassky <host> passing.html" with the server host
    Then the output should contain:
      """
      1 test timed out on 1 device
      """
    And the exit status should be 2
    
    