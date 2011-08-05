require 'spec_helper'

require 'spassky/pusher'

module Spassky
  describe Pusher do
    before do
      @response = mock("response", :code => 302, :headers => { "location" => "http://poll/me" })
      @server_url = "http://foo/"
      @sleeper = mock("sleeper")
      @sleeper.stub!(:sleep)
      @pusher = Pusher.new(@server_url, @sleeper)
      RestClient.stub!(:post).with("http://foo/test_run", "test contents"
        ).and_yield(@response, nil, nil)
      RestClient.stub!(:get)
    end
    
    it "pushes a test to the server" do
      RestClient.should_receive(:post).with("http://foo/test_run", "test contents"
        ).and_yield(@response, nil, nil)
      @pusher.push("test contents") do |result|
      end
    end
    
    it "fails nicely when the url does not redirect" do
      @response = mock("response", :code => 200, :headers => { })
      RestClient.stub!(:post).with("http://foo/test_run", "test contents"
        ).and_yield(@response, nil, nil)
      lambda {
        @pusher.push("test contents") do |result|
        end
      }.should raise_error("Expected http://foo/test_run to respond with 302")
    end
        
    it "polls the URL returned until the test passes" do
      RestClient.should_receive(:get).with("http://poll/me").and_return("in progress", "in progress", "in progress", "pass")
      @pusher.push("test contents") do |result|
      end
    end
    
    it "polls the URL returned until the test fails" do
      RestClient.should_receive(:get).and_return("in progress", "in progress", "fail")
      @pusher.push("test contents") {}
    end
    
    it "yields the outcome of the test to the block" do
      RestClient.stub!(:get).and_return("pass")
      yielded_result = ""
      Pusher.new(@server_url).push("test contents") do |result|
        yielded_result = result
      end
      yielded_result.should == "pass"
    end
    
    it "sleeps while looping during get requests" do
      RestClient.stub!(:get).and_return("in progress", "in progress", "in progress", "pass")
      @sleeper.should_receive(:sleep).with(0.4).exactly(3).times
      @pusher.push("test contents") { |result| }
    end
  end
end