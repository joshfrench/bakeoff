require 'bundler'
Bundler.require

$: << File.join(File.dirname(__FILE__), 'lib')
$: << File.join(File.dirname(__FILE__), %w(lib rubyvote lib))

require File.join(File.dirname(__FILE__), 'baked')
run Baked
