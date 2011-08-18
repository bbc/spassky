Feature: Device Connection
    In order to easily diagnose device connection issues
    As a JavaScript developer
    I want to be able to know what devices are connected

  Scenario: List One Connected Device
    Given a connected mobile device "The Device User Agent"
    And a connected mobile device "The Other Device User Agent"
    When I run `spassky devices`
    Then the output should contain:
    """
    The Device User Agent
    The Other Device User Agent
    """

