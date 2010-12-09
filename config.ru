require 'bundler'
Bundler.require

$: << File.join(File.dirname(__FILE__), 'lib')
$: << File.join(File.dirname(__FILE__), %w(lib rubyvote lib))

set :haml, :format => :html5

configure :development do
  set :mongo_db, 'baked_dev'
end

require File.join(File.dirname(__FILE__), 'baked')
run Baked
