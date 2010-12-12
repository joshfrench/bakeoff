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
      |ip       |taste                     |creativity                |
      |127.0.0.1|Cookies, Brownies, Muffins|Cookies, Muffins, Brownies|
      |127.0.0.2|Cookies, Muffins, Brownies|Muffins, Cookies, Brownies|
      |127.0.0.3|Cookies, Muffins, Brownies|Muffins, Cookies, Brownies|
  
  Scenario: Viewing while polls are open
    Given the polls are open
    When I go to the results page
    Then I should see "Not Found"
      
  Scenario: Viewing category winners
    Given the polls are closed
    When I go to the results page
    Then I should see "Cookies Muffins Brownies" within "#taste"
    And I should see "Muffins Cookies Brownies" within "#creativity"
