Feature: CLI usage

  Scenario: prints the usage when -h argument is given
    When I successfully run scube with option -h
    Then the output must contain exactly the usage

  Scenario: prints the usage when unknown option switch is given
    When I run scube with option --unknown-option
    Then the exit status must be 64
    And the output must contain exactly the usage
