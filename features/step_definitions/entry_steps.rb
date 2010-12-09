When /^I add an entry named "([^"]*)"$/ do |name|
    When "I fill in \"New Entry\" with \"#{name}\""
    And "I press \"Add Entry\""
end

