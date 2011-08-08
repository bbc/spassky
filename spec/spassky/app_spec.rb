require 'spec_helper'

require 'capybara'
require 'capybara/dsl'
require 'rack/test'

require 'spassky/app'

module Spassky
  describe App do
    include Rack::Test::Methods
    
    def app
      App
    end
    
    describe "GET /device/connect" do
      it "redirects to a unique URL" do
        RandomStringGenerator.should_receive(:random_string).and_return("random-string")
        get "/device/connect"
        last_response.should be_redirect
        last_response.location.should == "http://example.org/device/idle/random-string"
      end
    end
    
    describe "GET /device/idle/123" do
      it "serves HTML page with a meta-refresh tag" do
        RandomStringGenerator.should_receive(:random_string).and_return("next-iteration")
        get "/device/idle/123"
        seconds = 1
        url = "/device/idle/next-iteration"
        last_response.body.should include("<meta http-equiv=\"refresh\" content=\"#{seconds}; url='#{url}'\">")
      end
    end
    
    describe "POST /test_runs" do
      it "redirects to the status page" do
        RandomStringGenerator.should_receive(:random_string).and_return("number")
        post "/test_runs"
        last_response.should be_redirect
        last_response.location.should =~ /test_runs\/number$/
      end
    end
    
    describe "GET /test_runs/123" do
      it "returns 'in progress'" do
        get '/test_runs/123'
        last_response.body.should == 'in progress'
      end
    end
    
  end
end