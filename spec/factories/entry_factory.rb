Factory.define :entry do |e|
  e.sequence(:name) { |n| "Entry #{n}" }
end

