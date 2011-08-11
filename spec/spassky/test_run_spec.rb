require 'spec_helper'
require 'spassky/test_run'

module Spassky
  describe TestRun do
    before do
      TestRun.delete_all
    end
        
    it "can be created and retrieved" do
      created = TestRun.create(:name => "a test", :contents => "the contents")
      retrieved = TestRun.find(created.id)
      created.should == retrieved
    end
    
    it "assigns each test run a unique id" do
      test_run1 = TestRun.create(:name => "test run 1", :contents => "the contents")
      test_run2 =TestRun.create(:name => "test run 2", :contents => "the contents")
      test_run1.id.should_not == test_run2.id
    end

    it "finds a test run by it's id" do
      first = TestRun.create(:name => "test run 1", :contents => "the contents")
      second = TestRun.create(:name => "test run 2", :contents => "the contents")
      TestRun.find(first.id.to_s).should == first
      TestRun.find(second.id).should == second
    end

    it "returns the next test to run for each device" do
      created = TestRun.create(:name => "test", :contents => "contents", :devices => ["x", "y"])
      TestRun.find_next_to_run_for_user_agent("x").should == created
      TestRun.find_next_to_run_for_user_agent("y").should == created 
    end
    
    it "only returns a test run per user agent until results are saved" do
      created = TestRun.create(:name => "another test", :contents => "the contents of the test", :devices => ["user agent 1"])
      TestRun.find_next_to_run_for_user_agent("user agent 1").should == created
      TestRun.find_next_to_run_for_user_agent("user agent 1").should == created
      created.save_results_for_user_agent(:user_agent => "user agent 1", :status => "pass")
      TestRun.find_next_to_run_for_user_agent("user agent 1").should be_nil
    end
    
    it "returns 'in progress' status per user agent until the results are saved" do
      created = TestRun.create(:name => "another test", :contents => "the contents of the test")
      created.result.status.should == 'in progress'
      created.save_results_for_user_agent(:user_agent => "some user agent", :status => "pass")
      created.result.status.should == 'pass'
    end
    
    it "returns failed if the saved tests results failed" do
      created = TestRun.create(:name => "another test", :contents => "the contents of the test")
      created.save_results_for_user_agent(:user_agent => "another user agent", :status => "fail")
      created.result.status.should == 'fail'
    end
    
    it "rejects nonsense status" do
      run = TestRun.create(:name => "another test", :contents => "the contents of the test")
      lambda {
        run.save_results_for_user_agent(:user_agent => "another user agent", :status => "wtf?")
      }.should raise_error("wtf? is not a valid status")
    end
    
    it "creates an in progress test result from the device list" do
      run = TestRun.create(
        :name => "another test",
        :contents => "the contents of the test",
        :devices => ["device1", "device2"]
      )
      run.result.device_statuses.size.should == 2
      run.result.device_statuses.first.status.should == "in progress"
      run.result.device_statuses.last.status.should == "in progress"
    end
  end
end