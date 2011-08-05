require 'spec_helper'

require 'spassky/cli'

module Spassky
  describe Cli do
    let :pusher do
      mock(:pusher)
    end
    
    let :runner do
      mock(:runner, :run_test => true)
    end
    
    before do
      Pusher.stub!(:new).and_return(pusher)
      TestRunner.stub!(:new).and_return(runner)
    end
    
    it "creates a pusher with the server url as the first argument" do
      Pusher.should_receive(:new).with("server_name").and_return(pusher)
      TestRunner.should_receive(:new).with(pusher).and_return(runner)
      Cli::run(["server_name", "test_name"])
    end
    
    it "runs a single test with the name as the second argument" do
      runner.should_receive(:run_test).with("test_name")
      Cli::run(["server_name", "test_name"])
    end
  end
end