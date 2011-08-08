require 'spec_helper'

require 'spassky/test_runner'

module Spassky
  describe TestRunner do
    before do
      @test_pusher = mock(:test_pusher)
      @test_result = mock(:test_result)
      @test_result.stub!(:summary).and_return(:hello)
      File.stub!(:read).and_return('contents')
    end
    
    it "reads a test" do
      @test_pusher.stub!(:push)
      File.should_receive(:read).and_return(:file_body)
      TestRunner.new(@test_pusher).run_test("foo_test")
    end
    
    it "pushes the test" do
      @test_pusher.should_receive(:push).with({:name => 'foo_test', :contents => 'contents'})
      TestRunner.new(@test_pusher).run_test("foo_test")
    end
    
    it "prints a passed result when it arrives" do
      Kernel.should_receive(:puts).with(:hello)
      @test_pusher.should_receive(:push).and_yield(@test_result)
      TestRunner.new(@test_pusher).run_test("foo_test")
    end
  end
end