require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'

require 'aruba/cucumber'

require File.join(File.dirname(__FILE__), '../../lib/spassky')

World(Capybara::DSL)

Capybara.app = Spassky::App

Before do
  Capybara.default_driver = :selenium
  @aruba_timeout_seconds = 5
end

def register_driver_with_user_agent user_agent
  Capybara.register_driver :firefox_with_custom_user_agent do |app|
    require 'selenium/webdriver'
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['general.useragent.override'] = user_agent
    Capybara::Driver::Selenium.new(app, :profile => profile)
  end
  Capybara.default_driver = :firefox_with_custom_user_agent
end

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"