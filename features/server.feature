Feature: Server
  In order to spawn a spassky server
  As a developer
  I want to be able to type 'spassky-server' to launch a server

  Scenario: Launch Server
    Given I run spassky-server
    Then it should not crash
