require "spec_helper"

module Spassky
  describe TestSuiteResultSummariser do
    it "shows passing tests" do
      device_statuses = [
        FactoryGirl.build(:device_test_status),
        FactoryGirl.build(:device_test_status)
      ]
      TestSuiteResultSummariser.new(device_statuses).summary.should == "2 passed"
    end

    it "shows failing tests" do
      device_statuses = [
        FactoryGirl.build(:device_test_status, :status => 'fail'),
        FactoryGirl.build(:device_test_status, :status => 'fail')
      ]
      TestSuiteResultSummariser.new(device_statuses).summary.should == "2 failed"
    end

    it "shows timed out tests" do
      device_statuses = [
        FactoryGirl.build(:device_test_status, :status => 'timed out'),
        FactoryGirl.build(:device_test_status, :status => 'timed out')
      ]
      TestSuiteResultSummariser.new(device_statuses).summary.should == "2 timed out"
    end

    it "shows failed, passed and timed out tests" do
      device_statuses = [
        FactoryGirl.build(:device_test_status, :status => 'pass'),
        FactoryGirl.build(:device_test_status, :status => 'pass'),
        FactoryGirl.build(:device_test_status, :status => 'fail'),
        FactoryGirl.build(:device_test_status, :status => 'fail'),
        FactoryGirl.build(:device_test_status, :status => 'timed out'),
        FactoryGirl.build(:device_test_status, :status => 'timed out')
      ]
      TestSuiteResultSummariser.new(device_statuses).summary.should == "2 passed, 2 failed, 2 timed out"
    end
  end
end
