Feature: List Connected Devices
    In order to easily diagnose device connection issues
    As a JavaScript developer
    I want to be able to know what devices are connected

  Scenario: Two Connected Devices
    Given a Wireless Universal Resource FiLe
    And a connected mobile device "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3"
    And a connected mobile device "Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10"
    When I run "spassky devices <host>" with the server host
    Then the output should contain:
    """
    iPhone (id = apple_iphone_ver1_suba543, mobile_browser = Safari, device_os_version = 1.0)
    iPad (id = apple_ipad_ver1_sub5312110, mobile_browser = Safari, device_os_version = 3.2)
    """
