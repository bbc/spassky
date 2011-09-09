require 'spec_helper'
require 'spassky/test_suite_result'

module Spassky
  describe TestSuiteResult do
    context "when no devices are connected" do
      it "is in progress" do
        TestSuiteResult.new([]).status.should == "in progress"
      end
    end

    it "has a summary" do
      device_statuses = stub(:device_statuses)
      test_result_summariser = stub(:test_result_summariser)
      test_result_summariser.stub!(:summary).and_return("the summary")
      TestSuiteResultSummariser.stub!(:new).with(device_statuses).and_return(test_result_summariser)
      TestSuiteResult.new(device_statuses).summary.should == "the summary"
    end

    context "when all devices pass" do
      it "is a pass" do
        TestSuiteResult.new([
          FactoryGirl.build(:device_test_status),
          FactoryGirl.build(:device_test_status)
        ]).status.should == "pass"
      end
    end

    context "when any device fails" do
      it "is a fail" do
        TestSuiteResult.new([
          FactoryGirl.build(:device_test_status),
          FactoryGirl.build(:device_test_status, :status => 'fail')
        ]).status.should == "fail"
      end
    end

    context "when any test is still in progress" do
      it "is a fail" do
        TestSuiteResult.new([
          FactoryGirl.build(:device_test_status),
          FactoryGirl.build(:device_test_status, :status => 'fail'),
          FactoryGirl.build(:device_test_status, :status => 'in progress')
        ]).status.should == "in progress"
      end
    end

    context "when 1 test times out" do
      it "has the status 'timed out'" do
        test_suite_result = TestSuiteResult.new([
          FactoryGirl.build(:device_test_status, :status => 'timed out'),
          FactoryGirl.build(:device_test_status)
        ])
        test_suite_result.status.should == "timed out"
      end
    end

    it "can be serialized and deserialized" do
      device_test_statuses = [FactoryGirl.build(:device_test_status)]
      test_suite_result = TestSuiteResult.new(device_test_statuses)
      json = test_suite_result.to_json
      deserialized = TestSuiteResult.from_json(json)
      deserialized.device_statuses.size.should == 1
      deserialized.device_statuses.first.device_id.should == device_test_statuses.first.device_id
      deserialized.device_statuses.first.status.should    == device_test_statuses.first.status
      deserialized.device_statuses.first.message.should   == device_test_statuses.first.message
    end

    describe "#completed_since(nil)" do
      it "returns all device test results that are not in progress" do
        status_1 = FactoryGirl.build(:device_test_status)
        status_2 = FactoryGirl.build(:device_test_status, :status => 'in progress', :test_name => 'test2')
        status_3 = FactoryGirl.build(:device_test_status, :status => 'fail',        :test_name => 'test3')
        test_suite_result = TestSuiteResult.new([status_1, status_2, status_3])
        test_suite_result.completed_since(nil).should == [status_1, status_3]
      end
    end

    describe "#completed_since(other_test_suite_result)" do
      it "returns all device test results that are no longer in progress" do
        status_a1 = FactoryGirl.build(:device_test_status, :status => 'pass',        :test_name => 'test1')
        status_a2 = FactoryGirl.build(:device_test_status, :status => 'in progress', :test_name => 'test2')
        status_a3 = FactoryGirl.build(:device_test_status, :status => 'in progress', :test_name => 'test3')
        status_b1 = FactoryGirl.build(:device_test_status, :status => 'pass',        :test_name => 'test1')
        status_b2 = FactoryGirl.build(:device_test_status, :status => 'fail',        :test_name => 'test2')
        status_b3 = FactoryGirl.build(:device_test_status, :status => 'timed out',   :test_name => 'test3')

        test_suite_result_before = TestSuiteResult.new([status_a1, status_a2, status_a3])
        test_suite_result_after  = TestSuiteResult.new([status_b1, status_b2, status_b3])

        test_suite_result_after.completed_since(test_suite_result_before).should == [status_b2, status_b3]
      end
    end
  end
end
