ENV['RACK_ENV'] = 'test'
$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))
require 'spassky'
require 'factory_girl'
require 'factories'
