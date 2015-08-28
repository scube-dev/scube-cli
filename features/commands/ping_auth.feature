Feature: `ping:auth' command

  @vcr
  Scenario: prints server response on standard output with valid credentials
    Given I configure scube with valid credentials okr58vvNv6E9fXaFg8VPWeiG
    When I successfully run scube with command `ping:auth'
    Then the output must match /pong/

  @vcr
  Scenario: reports error with invalid credentials
    Given I configure scube with invalid credentials INVALID
    When I run scube with command `ping:auth'
    Then the output must match /scube.*authentication.*error/i
