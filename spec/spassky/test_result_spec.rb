require 'spec_helper'
require 'spassky/test_result'

module Spassky
  describe TestResult do
    context "when no devices are connected" do
      it "is in progress" do
        TestResult.new([]).status.should == "in progress"
      end
    end

    it "has a summary" do
      device_statuses = stub(:device_statuses)
      test_result_summariser = stub(:test_result_summariser)
      test_result_summariser.stub!(:summary).and_return("the summary")
      TestResultSummariser.stub!(:new).with(device_statuses).and_return(test_result_summariser)
      TestResult.new(device_statuses).summary.should == "the summary"
    end

    context "when all devices pass" do
      it "is a pass" do
        TestResult.new([
          Spassky::DeviceTestStatus.new({:device_id => 'agent1', :status => 'pass', :test_name => 'test'}),
          Spassky::DeviceTestStatus.new({:device_id => 'agent2', :status => 'pass', :test_name => 'test'})
        ]).status.should == "pass"
      end
    end

    context "when any device fails" do
      it "is a fail" do
        TestResult.new([
          Spassky::DeviceTestStatus.new({:device_id => 'agent1', :status => 'pass', :test_name => 'test'}),
          Spassky::DeviceTestStatus.new({:device_id => 'agent2', :status => 'fail', :test_name => 'test'})
        ]).status.should == "fail"
      end
    end

    context "when any test is still in progress" do
      it "is a fail" do
        TestResult.new([
          Spassky::DeviceTestStatus.new({:device_id => 'agent1', :status => 'pass', :test_name => 'test'}),
          Spassky::DeviceTestStatus.new({:device_id => 'agent2', :status => 'fail', :test_name => 'test'}),
          Spassky::DeviceTestStatus.new({:device_id => 'agent3', :status => 'in progress', :test_name => 'test'})
        ]).status.should == "in progress"
      end
    end

    context "when 1 test times out" do
      it "has the status 'timed out'" do
        test_result = TestResult.new([
          Spassky::DeviceTestStatus.new({:device_id => 'agent1', :status => 'timed out', :test_name => 'test'}),
          Spassky::DeviceTestStatus.new({:device_id => 'agent2', :status => 'pass', :test_name => 'test'})
        ])
        test_result.status.should == "timed out"
      end
    end

    it "can be serialized and deserialized" do
      test_result = TestResult.new([Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'pass', :test_name => 'test', :message => "test message"})])
      json = test_result.to_json
      deserialized = TestResult.from_json(json)
      deserialized.device_statuses.size.should == 1
      deserialized.device_statuses.first.device_id.should == 'agent'
      deserialized.device_statuses.first.status.should == 'pass'
      deserialized.device_statuses.first.message.should == "test message"
    end

    describe "#completed_since(nil)" do
      it "returns all device test results that are not in progress" do
        status_1 = Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'pass', :test_name => 'test1'})
        status_2 = Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'in progress', :test_name => 'test2'})
        status_3 = Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'fail', :test_name => 'test3'})
        test_result = TestResult.new([status_1, status_2, status_3])
        test_result.completed_since(nil).should == [status_1, status_3]
      end
    end

    describe "#completed_since(other_test_result)" do
      it "returns all device test results that are no longer in progress" do
        status_a1 = Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'pass',        :test_name => 'test1'})
        status_a2 = Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'in progress', :test_name => 'test2'})
        status_a3 = Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'in progress', :test_name => 'test3'})
        status_b1 = Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'pass',        :test_name => 'test1'})
        status_b2 = Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'fail',        :test_name => 'test2'})
        status_b3 = Spassky::DeviceTestStatus.new({:device_id => 'agent', :status => 'timed out',   :test_name => 'test3'})

        test_result_before = TestResult.new([status_a1, status_a2, status_a3])
        test_result_after  = TestResult.new([status_b1, status_b2, status_b3])

        test_result_after.completed_since(test_result_before).should == [status_b2, status_b3]
      end
    end
  end
end
