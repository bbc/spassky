require 'spec_helper'
require 'spassky/test_run'

module Spassky
  describe TestRun do
    before(:each) do
      TestRun.delete_all
    end
    
    it "can be created and retrieved" do
      created = TestRun.create(:name => "a test", :contents => "the contents")
      retrieved = TestRun.find(created.id)
      created.should == retrieved
    end
    
    it "only returns a test run per user agent until results are saved" do
      created = TestRun.create(:name => "another test", :contents => "the contents of the test")
      TestRun.find_next_to_run_for_user_agent("user agent 1").should == created
      TestRun.find_next_to_run_for_user_agent("user agent 1").should == created
      created.save_results_for_user_agent(:user_agent => "user agent 1", :status => "whatever")
      TestRun.find_next_to_run_for_user_agent("user agent 1").should be_nil
    end
    
    it "returns 'in progress' status per user agent until the results are saved" do
      created = TestRun.create(:name => "another test", :contents => "the contents of the test")
      created.status.should == "in progress"
      created.save_results_for_user_agent(:user_agent => "some user agent", :status => "passed")
      created.status.should == "passed"
    end
    
    it "returns failed if the saved tests results failed" do
      created = TestRun.create(:name => "another test", :contents => "the contents of the test")
      created.save_results_for_user_agent(:user_agent => "some user agent", :status => "failed")
      created.status.should == "failed"
    end
  end
end