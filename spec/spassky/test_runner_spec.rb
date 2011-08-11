require 'spec_helper'

require 'spassky/test_runner'

module Spassky
  describe TestRunner do
    before do
      @test_pusher = mock(:test_pusher)
      @test_result = mock(:test_result)
      @test_result.stub!(:summary).and_return("hello")
      @output = mock(:output)
      @output.stub!(:puts)
      File.stub!(:read).and_return('contents')
    end

    it "reads a test" do
      @test_pusher.stub!(:push)
      File.should_receive(:read).and_return(:file_body)
      TestRunner.new(@test_pusher, @output, {}).run_test("foo_test")
    end

    it "pushes the test" do
      @test_pusher.should_receive(:push).with({:name => 'foo_test', :contents => 'contents'})
      TestRunner.new(@test_pusher, @output, {}).run_test("foo_test")
    end

    it "prints a passed result when it arrives" do
      @output.should_receive(:puts).with("hello")
      @test_pusher.stub!(:push).and_yield(@test_result)
      TestRunner.new(@test_pusher, @output, {}).run_test("foo_test")
    end

    context "options contain colour flag" do
      context "failing test" do
        it "writes output in red" do
          @test_result.stub!(:status).and_return("fail")
          @test_pusher.stub!(:push).and_yield(@test_result)
          @output.should_receive(:puts).with("\e[31mhello\e[0m")
          TestRunner.new(@test_pusher, @output, {:colour => true}).run_test("foo_test")
        end
      end

      context "passing test" do
        it "writes output in green" do
          @test_result.stub!(:status).and_return("pass")
          @test_pusher.stub!(:push).and_yield(@test_result)
          @output.should_receive(:puts).with("\e[32mhello\e[0m")
          TestRunner.new(@test_pusher, @output, {:colour => true}).run_test("foo_test")
        end
      end
    end
  end
end
