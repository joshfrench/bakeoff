Feature: Managing entries
  As a bake-off manager
  I want to manage the list of entries
  So that employees can vote on stuff

  Background:
    Given I am on the entries index

  Scenario: Adding an entry
    When I add an entry named "Ruby scones"
    Then I should be on the entries index
    And I should see "Ruby scones"

  Scenario: Adding an invalid entry
    When I add an entry named ""
    Then I should see "Name can't be blank"

  Scenario: Adding a duplicate entry
    Given the following entry exists:
      |name    |
      |Brownies|
    When I add an entry named "Brownies"
    Then I should see "Name is already taken"

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

