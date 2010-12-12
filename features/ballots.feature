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

  Scenario: Filling out a new ballot
    Given I am on the ballot page
    Then I should see "Brownies" within "#taste"
    And I should see "Muffins" within "#taste"
    And I should see "Cookies" within "#taste"

  Scenario: Submitting a new vote
    Given I am on the ballot page
    And there are no ballots
    When I fill in "ballot_name" with "Josh"
    And I fill in "ballot_taste_cookies" with "0" within "#taste"
    And I fill in "ballot_taste_muffins" with "1" within "#taste"
    And I fill in "ballot_taste_brownies" with "2" within "#taste"
    And I press "Vote!"
    Then I should be on the ballot page
    And I should see "Thanks"

  Scenario: Submitting a duplicate ballot
    Given I am on the ballot page
    And a ballot exists
    When I fill in "ballot_name" with "User 1"
    And I press "Vote!"
    Then there should be 1 Ballot
    And I should see "I already have a vote from user 1@digitalpulp.com"

  Scenario: Submitting an invalid vote
    Given I am on the ballot page
    When I fill in "ballot_name" with ""
    And I press "Vote!"
    Then I should be on the ballot page
    And I should see "must enter your name"
