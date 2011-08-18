require 'spec_helper'
require 'spassky/client/cli'

module Spassky::Client
  describe Cli do
    let :pusher do
      mock(:pusher)
    end

    let :runner do
      mock(:runner, :run_tests => true)
    end

    before do
      Pusher.stub!(:new).and_return(pusher)
      TestRunner.stub!(:new).and_return(runner)
    end

    it "creates a pusher with the server url as the first argument" do
      Pusher.should_receive(:new).with("server_name").and_return(pusher)
      TestRunner.should_receive(:new).with(pusher, anything(), anything()).and_return(runner)
      Cli::run(["server_name", "test_name"])
    end

    it "runs a single test with the name as the second argument" do
      runner.should_receive(:run_tests).with("test_name")
      Cli::run(["server_name", "test_name"])
    end

    context "without colour output option" do
      it "creates a test runner with a default writer" do
        default_writer = mock :default_writer
        DefaultWriter.should_receive(:new).with(STDOUT).and_return(default_writer)
        TestRunner.should_receive(:new).with(anything(), default_writer, anything())
        Cli::run(["server_name", "test_name"])
      end
    end

    context "with colour output option" do
      it "creates a test runner with a colour writer" do
        coloured_writer = mock :coloured_writer
        ColouredWriter.should_receive(:new).with(STDOUT).and_return(coloured_writer)
        TestRunner.should_receive(:new).with(anything(), coloured_writer, anything())
        Cli::run(["server_name", "test_name", "--colour"])
      end
    end

    context "with devices as the second argument" do
      it "creates a new device list retriever with the passed in url" do
        device_list_retriever = mock :device_list_retriever
        device_list_retriever.stub!(:get_connected_devices).and_return([])
        DeviceListRetriever.should_receive(:new).with("http://localhost:9000").and_return(device_list_retriever)
        Cli::run(["http://localhost:9000", "devices"])
      end

      it "gets a list of devices" do
        device_list_retriever = mock :device_list_retriever
        device_list_retriever.should_receive(:get_connected_devices).and_return([])
        DeviceListRetriever.stub!(:new).and_return(device_list_retriever)
        Cli::run(["http://localhost:9000", "devices"])
      end

      it "outputs a list of devices" do
        device_list_retriever = mock :device_list_retriever
        device_list_retriever.stub!(:get_connected_devices).and_return(["iphone", "ipad", "nokia"])
        DeviceListRetriever.stub!(:new).and_return(device_list_retriever)
        Cli.should_receive(:puts).with("iphone")
        Cli.should_receive(:puts).with("ipad")
        Cli.should_receive(:puts).with("nokia")
        Cli::run(["http://localhost:9000", "devices"])
      end
    end
  end
end
