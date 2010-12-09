Given /^I have the following ballots:$/ do |table|
  table.hashes.each do |row|
    Factory.create :ballot, :ip => row[:ip], :taste => row[:taste].split(','), :creativity => row[:creativity].split(',')
  end
end

