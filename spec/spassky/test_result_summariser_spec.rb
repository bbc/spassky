require "spec_helper"

module Spassky
  describe TestResultSummariser do
    it "shows passing tests" do
      device_statuses = [
        DeviceTestStatus.new('agent1', 'pass', 'test'),
        DeviceTestStatus.new('agent2', 'pass', 'test')
      ]
      TestResultSummariser.new(device_statuses).summary.should == "2 passed"
    end

    it "shows failing tests" do
      device_statuses = [
        DeviceTestStatus.new('agent1', 'fail', 'test'),
        DeviceTestStatus.new('agent2', 'fail', 'test')
      ]
      TestResultSummariser.new(device_statuses).summary.should == "2 failed"
    end

    it "shows timed out tests" do
      device_statuses = [
        DeviceTestStatus.new('agent1', 'timed out', 'test'),
        DeviceTestStatus.new('agent2', 'timed out', 'test')
      ]
      TestResultSummariser.new(device_statuses).summary.should == "2 timed out"
    end

    it "shows failed, passed and timed out tests" do
      device_statuses = [
        DeviceTestStatus.new('agent1', 'pass', 'test'),
        DeviceTestStatus.new('agent2', 'pass', 'test'),
        DeviceTestStatus.new('agent3', 'fail', 'test'),
        DeviceTestStatus.new('agent4', 'fail', 'test'),
        DeviceTestStatus.new('agent5', 'timed out', 'test'),
        DeviceTestStatus.new('agent6', 'timed out', 'test')
      ]
      TestResultSummariser.new(device_statuses).summary.should == "2 passed, 2 failed, 2 timed out"
    end
  end
end
