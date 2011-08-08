require 'spec_helper'
require 'spassky/test_run'

module Spassky
  describe TestRun do
    it "can be created and retrieved" do
      created = TestRun.create(:name => "a test", :contents => "the contents")
      retrieved = TestRun.find(created.id)
      created.should == retrieved
    end
  end
end