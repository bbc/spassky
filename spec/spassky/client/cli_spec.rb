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
  end
end
