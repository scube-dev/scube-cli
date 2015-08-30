Feature: debug CLI option

  @vcr
  Scenario: logs client requests on standard output
    When I successfully run scube with option -d and command `ping'
    Then the output must match /get\s+http.+ping/i

  @vcr
  Scenario: logs server responses on standard output
    When I successfully run scube with option -d and command `ping'
    Then the output must match /status.+200.+ok/i
