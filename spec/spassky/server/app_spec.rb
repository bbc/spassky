require 'spec_helper'
require 'capybara'
require 'capybara/dsl'
require 'rack/test'
require 'json'

ENV["RACK_ENV"] = "test"
require 'spassky/server/app'

module Spassky::Server
  describe App do
    include Rack::Test::Methods

    before do
      RandomStringGenerator.stub!(:random_string).and_return("random-string")
      header "User-Agent", "some user agent"
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

    describe "GET /devices/list" do
      it "returns a list of devices" do
        devices = ["iphone", "nokia"]
        device_list.should_receive(:recently_connected_devices).and_return(devices)
        get "/devices/list"
        last_response.body.should == devices.to_json
      end
    end

    describe "GET /device/idle/123" do
      before do
        @device_database = mock :device_database
        SingletonDeviceDatabase.stub!(:instance).and_return(@device_database)
        @device_database.stub!(:device_identifier).and_return("anything")
        $stdout.stub!(:puts)
      end

      it "tells the device list that the device connected using the device identifier" do
        device_list.should_receive(:update_last_connected).with("anything")
        get "/device/idle/123"
      end

      it "writes out the device user agent" do
        $stdout.should_receive(:puts).with("Connected device: some user agent")
        $stdout.should_receive(:flush)
        get "/device/idle/123"
      end


      context "when there are no tests to run on the connected device" do
        it "serves HTML page with a meta-refresh tag" do
          TestRun.stub!(:find_next_test_to_run_by_device_id).and_return(nil)
          RandomStringGenerator.should_receive(:random_string).and_return("next-iteration")
          get "/device/idle/123"
          last_response.body.should include("<meta http-equiv=\"refresh\" content=\"1; url='/device/idle/next-iteration'\">")
        end
      end

      context "when there is a test to run on the connected device" do
        it "redirects to /test_runs/:id/run/:random/test_name" do
          RandomStringGenerator.stub!(:random_string).and_return("a-random-string")
          test = mock(:test, :contents => "test contents")
          test.stub!(:id).and_return("the-test-id")
          test.stub!(:name).and_return("the-test-name")
          TestRun.stub!(:find_next_test_to_run_by_device_id).with("anything").and_return(test)
          get '/device/idle/123'
          last_response.should be_redirect
          last_response.location.should == 'http://example.org/test_runs/the-test-id/run/a-random-string/the-test-name'
        end
      end
    end

    describe "GET /test_runs/:id/run/:random/assert" do
      it "saves the test result" do
        @device_database = mock(:device_database, :device_identifier => "the device identifier")
        SingletonDeviceDatabase.stub!(:instance).and_return(@device_database)
        test = mock(:test)
        TestRun.stub!(:find).with('123').and_return(test)
        test.should_receive(:save_result_for_device).with(
          :device_identifier => "the device identifier",
          :status            => "pass",
          :message           => "the_test_suite_result_message"
        )
        get "/test_runs/123/run/random/assert?status=pass&message=the_test_suite_result_message"
      end
    end

    describe "GET /test_runs/:id/run/:random/path/to/file" do
      it "gets the contents of the file" do
        test = mock(:test, :name => "fake_test.html.file", :contents => {})
        TestRun.stub!(:find).with('123').and_return(test)
        html_test = mock(:html_test)
        html_test.stub!(:get_file).and_return("contents")
        TestSuiteContainer.should_receive(:new).with({}, "/device/idle/random-string", "/test_runs/123/run/random/assert").and_return html_test
        get "/test_runs/123/run/random/fake_test.html.file"
        last_response.body.should == "contents"
      end
    end

    describe "POST /test_runs" do
      before do
        device_list.stub!(:recently_connected_devices).and_return(["foo", "bar"])
        @test_run = mock(:test_run)
        @test_run.stub!(:id).and_return(42)
        TestRun.stub!(:create).and_return(@test_run)
        RandomStringGenerator.stub!(:random_string).and_return("number")
        @test_contents = {"file1" => "file1 contents", "file2" => "file2 contents"}
      end

      context "no devices connected" do
        before do
          device_list.stub!(:recently_connected_devices).and_return([])
        end

        it "does not create a test run" do
          TestRun.should_not_receive(:create)
          post "/test_runs", { :name => "first-test", :contents => @test_contents.to_json }
        end

        it "halts with a 500" do
          post "/test_runs", { :name => "first-test", :contents => @test_contents.to_json }
          last_response.status.should == 500
        end

        it "displays the error" do
          post "/test_runs", { :name => "first-test", :contents => @test_contents.to_json }
          last_response.body.should == "There are no connected devices"
        end
      end

      it "creates a test run" do
        TestRun.should_receive(:create).with(:name => "first-test", :contents => @test_contents, :devices => ["foo", "bar"])
        post "/test_runs", { :name => "first-test", :contents => @test_contents.to_json }
      end

      it "redirects to the status page" do
        post "/test_runs", { :name => "first-test", :contents => @test_contents.to_json}
        last_response.should be_redirect
        last_response.location.should =~ /test_runs\/42$/
      end
    end

    describe "GET /test_runs/123" do
      it "returns the status of the test with the id '123'" do
        test_run = mock(:test_run)
        test_suite_result = mock(:test_suite_result)
        test_suite_result.stub!(:to_json).and_return("the test run as json")
        test_run.stub!(:result).and_return(test_suite_result)
        test_run.stub!(:update_connected_devices)
        TestRun.should_receive(:find).with('123').and_return test_run
        get '/test_runs/123'
        last_response.body.should == "the test run as json"
      end

      it "tells the test run which devices are still connected" do
        test_run = mock(:test_run)
        test_suite_result = mock(:test_suite_result)
        test_suite_result.stub!(:to_json).and_return("the test run as json")
        test_run.stub!(:result).and_return(test_suite_result)
        TestRun.stub!(:find).with('123').and_return test_run
        still_connected_devices = ["device1", "device2"]
        device_list.stub!(:recently_connected_devices).and_return(still_connected_devices)
        test_run.should_receive(:update_connected_devices).with(still_connected_devices)
        get '/test_runs/123'
      end
    end

  end
end
