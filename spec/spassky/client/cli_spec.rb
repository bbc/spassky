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

    describe "spassky run" do
      it "creates a pusher with the server url as the first argument" do
        Pusher.should_receive(:new).with("server_name").and_return(pusher)
        TestRunner.should_receive(:new).with(pusher, anything(), anything()).and_return(runner)
        Cli.new.run "test_name", "server_name"
      end

      it "runs a single test with the name as the second argument" do
        runner.should_receive(:run_tests).with("test_name")
        Cli.new.run "test_name", "server_name"
      end

      context "without colour output option" do
        it "creates a test runner with a default writer" do
          default_writer = mock :default_writer
          DefaultWriter.should_receive(:new).with(STDOUT).and_return(default_writer)
          TestRunner.should_receive(:new).with(anything(), default_writer, anything())
          Cli.new.run "test_name", "server_name"
        end
      end

      context "with colour output option" do
        it "creates a test runner with a colour writer" do
          coloured_writer = mock :coloured_writer
          ColouredWriter.should_receive(:new).with(STDOUT).and_return(coloured_writer)
          TestRunner.should_receive(:new).with(anything(), coloured_writer, anything())
          Cli.new.run "test_name", "server_name", "--colour"
        end
      end
    end

    context "spassky devices" do
      it "creates a new device list retriever with the passed in url" do
        device_list_retriever = mock :device_list_retriever
        device_list_retriever.stub!(:get_connected_devices).and_return([])
        DeviceListRetriever.should_receive(:new).with("http://localhost:9000").and_return(device_list_retriever)
        Cli.new.devices "http://localhost:9000"
      end

      it "gets a list of devices" do
        device_list_retriever = mock :device_list_retriever
        device_list_retriever.should_receive(:get_connected_devices).and_return([])
        DeviceListRetriever.stub!(:new).and_return(device_list_retriever)
        Cli.new.devices "http://localhost:9000"
      end

      it "outputs a list of devices" do
        device_list_retriever = mock :device_list_retriever
        device_list_retriever.stub!(:get_connected_devices).and_return(["iphone", "ipad", "nokia"])
        DeviceListRetriever.stub!(:new).and_return(device_list_retriever)
        cli = Cli.new
        cli.should_receive(:puts).with("iphone")
        cli.should_receive(:puts).with("ipad")
        cli.should_receive(:puts).with("nokia")
        cli.devices "http://localhost:9000"
      end
    end

    context "spassky server" do
      before do
        Spassky::Server::App.stub!(:run!)
      end

      context "without a port specified" do
        it "sets the default port" do
          Spassky::Server::App.should_receive(:set).with(:port, Cli::DEFAULT_PORT)
          Cli.new.server
        end
      end

      context "with a port specified" do
        it "uses the specified port" do
          Spassky::Server::App.should_receive(:set).with(:port, 9393)
          Cli.new.server(9393)
        end
      end

      it "launches the server" do
        Spassky::Server::App.should_receive(:run!)
        Cli.new.server
      end
    end
  end
end
