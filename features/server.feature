Feature: Server
  In order to spawn a spassky server
  As a developer
  I want to be able to type 'spassky-server' to launch a server

  Scenario: Launch Server
    Given I run spassky-server and then exit it
    Then I should see the output:
    """
    Sinatra/1.2.6 has taken the stage on 9191
    """
