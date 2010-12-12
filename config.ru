if ENV['MONGOHQ_URL']
  require 'uri'
  mongo_uri = URI.parse(ENV['MONGOHQ_URL'])
  ENV['MONGOID_HOST'] = mongo_uri.host
  ENV['MONGOID_PORT'] = mongo_uri.port.to_s
  ENV['MONGOID_USERNAME'] = mongo_uri.user
  ENV['MONGOID_PASSWORD'] = mongo_uri.password
  ENV['MONGOID_DATABASE'] = mongo_uri.path.gsub("/", "")

  %w(MONGOID_HOST MONGOID_PORT MONGOID_USERNAME MONGOID_DATABASE).each do |config|
    puts "#{config}: #{ENV[config]}"
  end
end

require 'bundler'
Bundler.require

$: << File.join(File.dirname(__FILE__), 'lib')
$: << File.join(File.dirname(__FILE__), %w(lib rubyvote lib))

require File.join(File.dirname(__FILE__), 'baked')
run Baked
