require 'spec_helper'

require 'capybara'
require 'capybara/dsl'

require 'spassky/app'

module Spassky
  describe App do
    include Capybara::DSL
    
    before do
      Capybara.app = App
    end
    
    describe "GET /device/connect" do
      it "redirects to a unique URL" do
        RandomStringGenerator.should_receive(:random_string).and_return("random-string", "random-string")
        visit "/device/connect"
        page.current_url.should == "http://www.example.com/device/idle/random-string"
      end
    end
    
    describe "GET /device/idle/123" do
      it "serves HTML page with a meta-refresh tag" do
        RandomStringGenerator.should_receive(:random_string).and_return("next-iteration")
        visit "/device/idle/123"
        seconds = 1
        url = "/device/idle/next-iteration"
        page.html.should include("<meta http-equiv=\"refresh\" content=\"#{seconds}; url='#{url}'\">")
      end
    end
  end
end