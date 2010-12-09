Feature: Submitting a ballot
  As an employee
  I want to vote on delicious baked goods
  So I can exercise the power of democracy

  Background:
    Given the following entries exist:
      |name    |
      |Brownies|
      |Muffins |
      |Cookies |

  Scenario: Viewing the entries
    Given I am on the new ballot page
    Then I should see "Brownies" within ".taste"
    And I should see "Muffins" within ".taste"
    And I should see "Cookies" within ".taste"

  Scenario: Submitting a new vote
    Given I am on the new ballot page
    When I fill in "Cookies" with "0" within ".taste"
    And I fill in "Muffins" with "1" within ".taste"
    And I fill in "Brownies" with "2" within ".taste"
    And I press "Vote!"
    Then I should be on the new ballot page
    And I should see "Update your vote"

  Scenario: Revising an existing vote
    Given a ballot exists
    When I go to the new ballot page
    Then the "Cookies" field within ".taste" should contain "0"
    And the "Muffins" field within ".taste" should contain "1"
    And the "Brownies" field within ".taste" should contain "2"
