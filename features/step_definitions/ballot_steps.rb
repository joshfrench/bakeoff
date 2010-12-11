Given /^there are no ballots$/ do
  Ballot.destroy_all
end

Then /^there should be (\d+) Ballots?$/ do |count|
  Ballot.count.should == count.to_i
end

