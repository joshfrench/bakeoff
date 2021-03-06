# Generated by cucumber-sinatra. (2010-12-08 14:12:18 -0500)

ENV['RACK_ENV'] = 'test'

require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'mongoid'
require 'factory_girl'

$: << File.join(File.dirname(__FILE__), %w(.. .. lib))
$: << File.join(File.dirname(__FILE__), %w(.. .. lib rubyvote lib))

Mongoid.configure do |config|
  host = ENV['MONGOID_HOST']     || 'localhost'
  name = ENV['MONGOID_DATABASE'] || 'baked_test'
  port = ENV['MONGOID_PORT']     || Mongo::Connection::DEFAULT_PORT
  config.master = Mongo::Connection.new(host, port).db(name)
end

Dir[File.expand_path(File.join(File.dirname(__FILE__),%w(.. .. spec factories *.rb)))].each {|f| require f}

require File.join(File.dirname(__FILE__), %w(.. .. baked))

Capybara.app = Baked

class BakedWorld
  include Capybara
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  BakedWorld.new
end

