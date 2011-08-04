require 'spec_helper'

require 'spassky/test_runner'

module Spassky
  describe TestRunner do
    it "reads a test" do
      test_pusher = mock(:test_pusher)
      test_pusher.stub!(:push)
      File.should_receive(:read).and_return(:file_body)
      TestRunner.new(test_pusher).run_test("foo_test")
    end
    
    it "pushes the test" do
      test_pusher = mock(:test_pusher)
      File.stub!(:read).and_return(:file_body)
      test_pusher.should_receive(:push).with(:file_body)
      TestRunner.new(test_pusher).run_test("foo_test")
    end
    
    it "prints the result when it arrives" do
      test_pusher = mock(:test_pusher)
      File.stub!(:read).and_return(:file_body)
      Kernel.should_receive(:puts).with("1 test passed")
      test_pusher.should_receive(:push).with(:file_body).and_yield
      TestRunner.new(test_pusher).run_test("foo_test")
    end
  end
end