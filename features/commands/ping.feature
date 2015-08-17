Feature: `ping' command

  @vcr
  Scenario: prints server response on standard output
    When I successfully run scube with command `ping'
    Then the output must match /pong/
