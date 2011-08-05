require 'spec_helper'

require 'spassky/pusher'

module Spassky
  describe Pusher do
    before do
      @response = mock("response", :code => 302, :headers => { "location" => "http://poll/me" })
      @url = "http://foo/test_run"
      @sleeper = mock("sleeper")
      @sleeper.stub!(:sleep)
      @pusher = Pusher.new(@url, @sleeper)
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
      Pusher.new(@url).push("test contents") do |result|
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