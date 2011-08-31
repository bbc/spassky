require "spec_helper"

module Spassky
  describe TestResultSummariser do
    it "shows passing tests" do
      device_statuses = [
        Spassky::DeviceTestStatus.new('agent1', 'pass', 'test'),
        Spassky::DeviceTestStatus.new('agent2', 'pass', 'test')
      ]
      TestResultSummariser.new(device_statuses).summary.should == "2 passed"
    end
  end
end
