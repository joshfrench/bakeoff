When /^I add an entry named "([^"]*)"$/ do |name|
    When "I fill in \"Name of dish:\" with \"#{name}\""
    And "I press \"Add Entry\""
end
