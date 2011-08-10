require 'spec_helper'
require 'spassky/test_result'

module Spassky
  describe TestResult do
    context "when no devices are connected" do
      it "is in progress" do
        TestResult.new([]).status.should == "in progress"
      end
    end
    
    context "when one device passes" do
      it "outputs a summary" do
        test_result = TestResult.new([
          DeviceTestStatus.new('agent1', 'pass')
        ])
        test_result.summary.should == "1 test passed on 1 device"
      end
    end

    context "when all devices pass" do
      it "is a pass" do
        TestResult.new([
          DeviceTestStatus.new('agent1', 'pass'),
          DeviceTestStatus.new('agent2', 'pass')
        ]).status.should == "pass"
      end
      
      it "outputs a pluralised summary" do
        test_result = TestResult.new([
          DeviceTestStatus.new('agent1', 'pass'),
          DeviceTestStatus.new('agent2', 'pass')
        ])
        test_result.summary.should == "1 test passed on 2 devices"
      end
    end
    
    context "when any device fails" do
      it "is a fail" do
        TestResult.new([
          DeviceTestStatus.new('agent1', 'pass'),
          DeviceTestStatus.new('agent2', 'fail')
        ]).status.should == "fail"
      end
      
      it "outputs a summary" do
        test_result = TestResult.new([
          DeviceTestStatus.new('agent1', 'fail')
        ])
        test_result.summary.should == "1 test failed on 1 device"
      end
    end
    
    context "when any test is still in progress" do
      it "is a fail" do
        TestResult.new([
          DeviceTestStatus.new('agent1', 'pass'),
          DeviceTestStatus.new('agent2', 'fail'),
          DeviceTestStatus.new('agent3', 'in progress')
        ]).status.should == "in progress"
      end
    end
    
    it "can be serialized and deserialized" do
      test_result = TestResult.new([DeviceTestStatus.new('agent', 'pass')])
      json = test_result.to_json
      deserialized = TestResult.from_json(json)
      deserialized.device_statuses.size.should == 1
      deserialized.device_statuses.first.user_agent.should == 'agent'
      deserialized.device_statuses.first.status.should == 'pass'      
    end
  end
end