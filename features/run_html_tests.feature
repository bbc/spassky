Feature: Run HTML Tests

  In order to inform design decisions
  As a web developer
  I want to test HTML code on different web browsers

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

  Scenario: No connected devices
    Given I have no connected devices
    When I run "spassky run passing.html <host>" with the server host
    Then the output should contain:
      """
      There are no connected devices
      """
    And the exit status should be 1

  Scenario: One device with a user agent that exists in WURFL
    Given a connected mobile device "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3"
    When I run "spassky run passing.html <host>" with the server host
    Then the output should contain:
      """
      PASS passing.html on iPhone (id = apple_iphone_ver1_suba543, mobile_browser = Safari, device_os_version = 1.0)
      """
    And the exit status should be 0

  Scenario: One passing test on one device
    Given a connected mobile device "blackberry"
    When I run "spassky run passing.html <host>" with the server host
    Then the output should contain:
      """
      PASS passing.html on blackberry
      """
    And the exit status should be 0

  Scenario: One passing test on two devices
    Given a connected mobile device "blackberry"
    And a connected mobile device "iphone"
    When I run "spassky run passing.html <host>" with the server host
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
    When I run "spassky run failing.html <host>" with the server host
    Then the output should contain:
      """
      FAIL failing.html on blackberry
      """
    And the exit status should be 1

  Scenario: Failing Test with Message
    Given a connected mobile device "blackberry"
    When I run "spassky run failing.html <host>" with the server host
    Then the output should contain:
      """
      FAIL failing.html on blackberry
      This test should fail
      """
    And the exit status should be 1
