require 'spec_helper'
require 'spassky/client/pusher'

module Spassky::Client
  describe Pusher do
    before do
      @response = mock("response", :code => 302, :headers => { :location => "http://poll/me" })
      @server_url = "http://foo/"
      @sleeper = mock("sleeper")
      @sleeper.stub!(:sleep)
      @pusher = Pusher.new(@server_url, @sleeper)
      RestClient.stub!(:post).with("http://foo/test_runs", "test contents"
        ).and_yield(@response, nil, nil)
      RestClient.stub!(:get).and_return(passed_status)
    end

    def in_progress_status
      Spassky::TestResult.new([Spassky::DeviceTestStatus.new('agent', 'in progress', 'test')]).to_json
    end

    def passed_status
      Spassky::TestResult.new([Spassky::DeviceTestStatus.new('agent', 'pass', 'test')]).to_json
    end

    def failed_status
      Spassky::TestResult.new([Spassky::DeviceTestStatus.new('agent', 'fail', 'test')]).to_json
    end

    it "pushes a test to the server" do
      RestClient.should_receive(:post).with("http://foo/test_runs", {:contents => 'test contents'}
        ).and_yield(@response, nil, nil)
      @pusher.push({:contents => "test contents"}) do |result|
      end
    end

    it "fails nicely when the url does not redirect" do
      @response = mock("response", :code => 200, :headers => { })
      RestClient.stub!(:post).with("http://foo/test_runs", "test contents"
        ).and_yield(@response, nil, nil)
      lambda {
        @pusher.push("test contents") do |result|
        end
      }.should raise_error("Expected http://foo/test_runs to respond with 302")
    end

    it "polls the URL returned until the test passes" do
      RestClient.should_receive(:get).with("http://poll/me").and_return(in_progress_status, in_progress_status, in_progress_status, passed_status)
      @pusher.push("test contents") do |result|
      end
    end

    it "polls the URL returned until the test fails" do
      RestClient.should_receive(:get).and_return(in_progress_status, in_progress_status, failed_status)
      @pusher.push("test contents") {}
    end

    it "yields the outcome of the test to the block" do
      RestClient.stub!(:get).and_return(in_progress_status, in_progress_status, passed_status)
      yielded_results = []
      @pusher.push("test contents") do |result|
        yielded_results << result.to_json
      end
      yielded_results.should == [in_progress_status, in_progress_status, passed_status]
    end

    it "sleeps while looping during get requests" do
      RestClient.stub!(:get).and_return(in_progress_status, in_progress_status, in_progress_status, passed_status)
      @sleeper.should_receive(:sleep).with(0.4).exactly(3).times
      @pusher.push("test contents") { |result| }
    end
  end
end
