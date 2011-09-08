require "spec_helper"

module Spassky
  describe TestResultSummariser do
    it "shows passing tests" do
      device_statuses = [
        DeviceTestStatus.new(:device_id => 'agent1', :status => 'pass', :test_name => 'test'),
        DeviceTestStatus.new(:device_id => 'agent2', :status => 'pass', :test_name => 'test')
      ]
      TestResultSummariser.new(device_statuses).summary.should == "2 passed"
    end

    it "shows failing tests" do
      device_statuses = [
        DeviceTestStatus.new(:device_id => 'agent1', :status => 'fail', :test_name => 'test'),
        DeviceTestStatus.new(:device_id => 'agent2', :status => 'fail', :test_name => 'test')
      ]
      TestResultSummariser.new(device_statuses).summary.should == "2 failed"
    end

    it "shows timed out tests" do
      device_statuses = [
        DeviceTestStatus.new(:device_id => 'agent1', :status => 'timed out', :test_name => 'test'),
        DeviceTestStatus.new(:device_id => 'agent2', :status => 'timed out', :test_name => 'test')
      ]
      TestResultSummariser.new(device_statuses).summary.should == "2 timed out"
    end

    it "shows failed, passed and timed out tests" do
      device_statuses = [
        DeviceTestStatus.new(:device_id => 'agent1', :status => 'pass', :test_name => 'test'),
        DeviceTestStatus.new(:device_id => 'agent2', :status => 'pass', :test_name => 'test'),
        DeviceTestStatus.new(:device_id => 'agent3', :status => 'fail', :test_name => 'test'),
        DeviceTestStatus.new(:device_id => 'agent4', :status => 'fail', :test_name => 'test'),
        DeviceTestStatus.new(:device_id => 'agent5', :status => 'timed out', :test_name => 'test'),
        DeviceTestStatus.new(:device_id => 'agent6', :status => 'timed out', :test_name => 'test')
      ]
      TestResultSummariser.new(device_statuses).summary.should == "2 passed, 2 failed, 2 timed out"
    end
  end
end
