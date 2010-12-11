Factory.define :ballot do |b|
  b.ip '127.0.0.1'
  b.sequence(:name) { |n| "user #{n}" }
  b.taste %w(Cookies Muffins Brownies)
end
