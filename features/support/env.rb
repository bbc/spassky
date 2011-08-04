require 'capybara'
require 'capybara/dsl'
require 'aruba/cucumber'

require File.join(File.dirname(__FILE__), '../../lib/spassky')

World(Capybara::DSL)

Capybara.app = Spassky::App

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"