require 'spec_helper'

require 'capybara'
require 'capybara/dsl'
require 'rack/test'
require 'json'

require 'spassky/app'

module Spassky
  describe App do
    include Rack::Test::Methods
    
    before do
      RandomStringGenerator.stub!(:random_string).and_return("random-string")
    end
    
    def app
      App.new(device_list)
    end
    
    let :device_list do
      mock(:device_list, :update_last_connected => true, :recently_connected_devices => [])
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
      
      it "tells the device list that the device connected" do
        device_list.should_receive(:update_last_connected).with("some user agent")
        header "User-Agent", "some user agent"
        get "/device/idle/123"
      end
      
      describe "when there are no tests to run on the connected device" do
        it "serves HTML page with a meta-refresh tag" do
          TestRun.stub!(:find_next_to_run_for_user_agent).and_return(nil)
          RandomStringGenerator.should_receive(:random_string).and_return("next-iteration")
          get "/device/idle/123"
          last_response.body.should include("<meta http-equiv=\"refresh\" content=\"1; url='/device/idle/next-iteration'\">")
        end        
      end
      
      describe "when there is a test to run on the connected device" do
        it "redirects to /test_runs/:id/run/:random" do
          RandomStringGenerator.stub!(:random_string).and_return("a-random-string")
          test = mock(:test, :contents => "test contents")
          test.stub!(:id).and_return("the-test-id")
          TestRun.stub!(:find_next_to_run_for_user_agent).with("some user agent").and_return(test)          
          header "User-Agent", "some user agent"
          get '/device/idle/123'
          last_response.should be_redirect
          last_response.location.should == 'http://example.org/test_runs/the-test-id/run/a-random-string'
        end
      end
    end
    
    describe "GET /test_runs/:id/run/assert" do
      it "saves the test result" do
        test = mock(:test)
        TestRun.stub!(:find).with('123').and_return(test)
        header "User-Agent", "the user agent"
        test.should_receive(:save_results_for_user_agent).with(:user_agent => "the user agent", :status => "pass")
        get "/test_runs/123/run/assert?status=pass"
      end
    end
    
    describe "GET /test_runs/:id/run/:random" do
      it "runs the test" do
        test = mock(:test, :contents => "test contents")
        TestRun.stub!(:find).with('123').and_return(test)
        header "User-Agent", "some user agent"
        get "/test_runs/123/run/random"
        last_response.body.should include("test contents")
      end
      
      describe "when the test contents includes a </head> tag" do
        it "adds a meta-refresh tag to the test contents" do
          test = mock(:test, :contents => "</head>")
          TestRun.stub!(:find).with('123').and_return(test)
          RandomStringGenerator.should_receive(:random_string).and_return("next-iteration")
          get "/test_runs/123/run/random"
          url = "/device/idle/next-iteration"
          last_response.body.should include("<meta http-equiv=\"refresh\" content=\"1; url='#{url}'\"></head>")
        end
        
        it "adds the assert.js script to the head" do
          test = mock(:test, :contents => "</head>")
          TestRun.stub!(:find).with('123').and_return(test)
          File.should_receive(:read).and_return("assert.js!")
          get "/test_runs/123/run/random"
          last_response.body.should include("<script type=\"text/javascript\">assert.js!</script>")
        end
      end
    end
    
    describe "POST /test_runs" do
      before do
        device_list.stub!(:recently_connected_devices).and_return(["foo", "bar"])
        @test_run = mock(:test_run)
        @test_run.stub!(:id).and_return(42)
        TestRun.stub!(:create).and_return(@test_run)
        RandomStringGenerator.stub!(:random_string).and_return("number")
      end
      
      it "creates a test run" do
        TestRun.should_receive(:create).with(:name => "first-test", :contents => "test-contents", :devices => ["foo", "bar"])
        post "/test_runs", { :name => "first-test", :contents => "test-contents" }
      end
      
      it "redirects to the status page" do
        post "/test_runs", { :name => "first-test", :contents => "test-contents"}
        last_response.should be_redirect
        last_response.location.should =~ /test_runs\/42$/
      end
    end
    
    describe "GET /test_runs/123" do
      it "returns the status of the test with the id '123'" do
        test_run = mock(:test_run)
        test_result = mock(:test_result)
        test_result.stub!(:to_json).and_return("the test run as json")
        test_run.stub!(:result).and_return(test_result)
        TestRun.should_receive(:find).with('123').and_return test_run
        get '/test_runs/123'
        last_response.body.should == "the test run as json"
      end
    end
    
  end
end
