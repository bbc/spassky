require 'spec_helper'

require 'spassky/pusher'

module Spassky
  describe Pusher do
    it "pushes a test to the server" do
      response = mock("response", :code => 302, :headers => { "location" => "http://poll/me" })
      RestClient.stub!(:get)
      RestClient.should_receive(:post).with("http://foo/test_run", "test contents"
        ).and_yield(response, nil, nil)
      Pusher.new("http://foo/test_run").push("test contents")
    end
    
    it "polls the URL returned until it indicates completion" do
      response = mock("response", :code => 302, :headers => { "location" => "http://poll/me" })
      RestClient.should_receive(:post).with("http://foo/test_run", "test contents"
        ).and_yield(response, nil, nil)
      RestClient.should_receive(:get).and_return("in progress")
      RestClient.should_receive(:get).and_return("in progress")
      RestClient.should_receive(:get).and_return("in progress")
      RestClient.should_receive(:get).and_return("pass")
      Pusher.new("http://foo/test_run").push("test contents")
    end
  end
end