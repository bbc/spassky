require 'spec_helper'

require 'spassky/cli'

module Spassky
  describe Cli do
    it "runs a single test passed as a command line arg" do
      runner = mock(:runner)
      TestRunner.stub!(:new).and_return(runner)
      runner.should_receive(:run_test).with("foo_test")
      Cli::run(["foo_test"])
    end
  end
end