Feature: Server
  In order to spawn a spassky server
  As a developer
  I want to be able to type 'spassky server 9393' to launch a server

  Scenario: Launch Server
    Given I run the command "spassky server 9393"
    Then it should not crash
