Feature: Summary
  In order to gauge the state of the project
  As a News stakeholder
  I want to summarised test results aftr a test run

  Background: Two tests, one passes, one fails
    Given a file named "passing.html" with:
      """
        <html>
          <head></head>
          <body>
          <script type="text/javascript">
          new Spassky().assert(true, 'this test should pass');
          </script>
          </body>
        </html>
      """
    And a file named "failing.html" with:
      """
        <html>
          <head></head>
          <body>
          <script type="text/javascript">
          new Spassky().assert(false, 'this test should fail');
          </script>
          </body>
        </html>
      """

  Scenario: One test passing on all devices
    Given I have two connected devices
    When I run "spassky run --pattern passing.html --test passing.html --server <host>" with the server host
    Then the output should contain "2 passed"
