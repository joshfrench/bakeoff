Factory.define :ballot do |b|
  b.sequence(:ip) { |n| "127.0.0.#{n}" }
  b.taste %w(Cookies Muffins Brownies)
end
