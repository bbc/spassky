Feature: Device Timeout
  In order for a clean test run
  As a Developer-in-Test
  I want to ignore devices that haven't connected recently

  Background: One passing test
    Given a file named "timed-out.html" with:
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

  Scenario: One device times out
    Given a connected mobile device "ipad"
    And I have a timeout of 5 seconds
    When the device disconnects
    And I run "spassky run --pattern timed-out.html --test timed-out.html --server <host>" with the server host
    Then the output should contain:
      """
      TIMED OUT timed-out.html on ipad
      """
    And the exit status should be 2
