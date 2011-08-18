$:.unshift(File.join(File.dirname(__FILE__), "lib"))

require 'spassky'
require 'spassky/server'

run Spassky::Server::App.new()
