require File.join(File.dirname(__FILE__), '..', 'baked.rb')
 
require 'sinatra'
require 'rack/test'
require 'mongoid'
require 'factory_girl'
require 'ruby-debug'

RSpec.configure do |config|
  config.mock_with :rspec
  config.before :suite do
    Mongoid.master.collections.select{|c| c.name !~ /system/}.each(&:drop)
  end
end

Mongoid.configure do |config|
  host = ENV['MONGOID_HOST']     || 'localhost'
  name = ENV['MONGOID_DATABASE'] || 'baked_test'
  port = ENV['MONGOID_PORT']     || Mongo::Connection::DEFAULT_PORT
  config.master = Mongo::Connection.new(host, port).db(name)
end

configure do
  set :environment, :test
  set :run, false
  set :raise_errors, true
  set :logging, false
end

def app
  @app ||= Baked
end
