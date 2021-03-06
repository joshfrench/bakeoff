Given /^I have the following ballots:$/ do |table|
  table.hashes.each do |row|
    taste = row[:taste].split(',').map {|t| Entry.where(:name => t.strip).first }
    creativity = row[:creativity].split(',').map {|c| Entry.where(:name => c.strip).first }
    Factory.create :ballot, :ip => row[:ip], :taste => taste.map(&:id), :creativity => creativity.map(&:id)
  end
end

Given /^the polls are closed$/ do
  ENV['POLLS_CLOSED'] = 'true'
end

Given /^the polls are open$/ do
  ENV['POLLS_CLOSED'] = nil
end
