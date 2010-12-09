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

  Scenario: Submitting a new vote
    Given I am on the new ballot page
    When I fill in "Cookies" with "1" within "taste"
    And I fill in "Muffins" with "2" within "taste"
    And I fill in "Brownies" with "3" within "taste"
    And I press "Vote!"
    Then I should have a ballot with:
      |category|entry   |rank|
      |taste   |Cookies |1   |
      |taste   |Muffins |2   |
      |taste   |Brownies|3   |

  Scenario: Revising an existing vote
