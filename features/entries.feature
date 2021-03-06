Feature: Adding new entries
  As an employee
  I want to add my awesome baked good
  So I can get in on this thing

  Background:
    Given I am on the new entry page

  Scenario: Adding an entry
    When I add an entry named "Ruby scones"
    Then I should be on the "Ruby scones" entry page
    And I should see "Ruby scones" within "h3"

  Scenario: Adding an invalid entry
    When I add an entry named ""
    Then I should be on the entries index
    And I should see "name can't be blank"

  Scenario: Adding a duplicate entry
    Given the following entry exists:
      |name    |
      |Brownies|
    When I add an entry named "Brownies"
    Then I should be on the entries index
    And I should see "name is already taken"
