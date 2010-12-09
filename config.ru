require 'bundler'
Bundler.require

require './baked'

set :haml, :format => :html5

configure :development do
  set :mongo_db, 'baked_dev'
end

run Baked
