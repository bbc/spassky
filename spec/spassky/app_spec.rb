require 'spec_helper'

require 'capybara'
require 'capybara/dsl'
require 'rack/test'

require 'spassky/app'

module Spassky
  describe App do
    include Rack::Test::Methods
    
    before do
      RandomStringGenerator.stub!(:random_string).and_return("random-string")
    end
    
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
      before do
        TestRun.stub!(:create).with(:name => "first-test", :contents => "test-contents")
        RandomStringGenerator.stub!(:random_string).and_return("number")
      end
      
      it "creates a test run" do
        TestRun.should_receive(:create).with(:name => "first-test", :contents => "test-contents")
        post "/test_runs", { :name => "first-test", :contents => "test-contents"}
      end
      
      it "redirects to the status page" do
        post "/test_runs", { :name => "first-test", :contents => "test-contents"}
        last_response.should be_redirect
        last_response.location.should =~ /test_runs\/number$/
      end
    end
    
    describe "GET /test_runs/123" do
      it "returns the status of the test with the id '123'" do
        test_run = mock
        test_run.stub!(:status).and_return 'a status'
        TestRun.should_receive(:find).with('123').and_return test_run
        get '/test_runs/123'
        last_response.body.should == 'a status'
      end
    end
    
  end
end
