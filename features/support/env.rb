require 'capybara'
require 'capybara/dsl'
require 'aruba/cucumber'

require File.join(File.dirname(__FILE__), '../../lib/app')

World(Capybara::DSL)

Capybara.app = App

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"