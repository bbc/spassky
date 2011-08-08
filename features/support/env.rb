require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'

require 'aruba/cucumber'

require File.join(File.dirname(__FILE__), '../../lib/spassky')

World(Capybara::DSL)

Capybara.app = Spassky::App

Before do
  @aruba_timeout_seconds = 5
end

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"