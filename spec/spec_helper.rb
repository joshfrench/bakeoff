require 'sinatra'
require 'rack/test'
require 'mongoid'
require 'factory_girl'
require 'ruby-debug'

$: << File.join(File.dirname(__FILE__), %w(.. lib))
$: << File.join(File.dirname(__FILE__), %w(.. lib rubyvote lib))

Mongoid.configure do |config|
  host = ENV['MONGOID_HOST']     || 'localhost'
  name = ENV['MONGOID_DATABASE'] || 'baked_test'
  port = ENV['MONGOID_PORT']     || Mongo::Connection::DEFAULT_PORT
  config.master = Mongo::Connection.new(host, port).db(name)
end

require File.join(File.dirname(__FILE__), '..', 'baked.rb')

RSpec.configure do |config|
  config.mock_with :rspec
  config.after :all do
    Mongoid.master.collections.select{|c| c.name !~ /system/}.each(&:drop)
  end
end

Dir[File.expand_path(File.join(File.dirname(__FILE__),%w(factories *.rb)))].each {|f| require f}

configure do
  set :environment, :test
  set :run, false
  set :raise_errors, true
  set :logging, false
end

def app
  @app ||= Baked
end
