Feature: Managing entries
  As a bake-off manager
  I want to manage the list of entries
  So that employees can vote on stuff

  Scenario: Viewing the entries
    Given the following entries exist:
      |name    |
      |Cookies |
      |Cupcakes|
      |Pie     |
    When I go to the entries index
    Then I should see "Cookies"
    And I should see "Cupcakes"
    And I should see "Pie"

  Scenario: Removing an entry
    Given the following entry exists:
      |name   |
      |Muffins|
    When I go to the entries index
    And I press "Remove"
    Then I should be on the entries index
    And I should not see "Muffins"

