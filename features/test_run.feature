Feature: Test Run
  
  In order to inform design decisions
  As a mobile tester
  I want to collate test results from multiple devices

  @javascript
  Scenario: Connect a device
    Given a connected mobile device
    Then it should wait for a test to run

  Scenario: Run test on a device
    Given a connected mobile device
    And a file named "mytest.html" with:
      """
        <html>
          <body>
          <script type="text/javascript">
          assert(true, 'the test should pass');
          </script>
          </body>
        </html>
      """
    When I run `spassky mytest.html`
    Then the output should contain:
      """
      1 test passed
      """