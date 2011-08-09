Feature: Connection
  In order to run tests with minimal effort
  As a web developer
  I want to connect devices to a constantly running service
  
  Scenario: Connect a device
    Given a connected mobile device "ipad"
    Then it should wait for a test to run