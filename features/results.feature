Feature: Tabulating results
  As a contestant
  I want to see if my delicious baked good won
  So I can get the loot

  Background:
    Given the following entries exist:
      |name    |
      |Cookies |
      |Brownies|
      |Muffins |
    And I have the following ballots:
      |ip       |taste                     |
      |127.0.0.1|Cookies, Brownies, Muffins|
      |127.0.0.2|Cookies, Muffins, Brownies|
  
  Scenario: Viewing the winners
    When I go to the results page
    Then I should see "Cookies" within ".taste"
