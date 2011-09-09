require 'spec_helper'
require 'spassky/client/test_suite_runner'

module Spassky::Client
  describe TestSuiteRunner do
    before do
      @test_pusher = mock(:test_pusher)
      @writer = mock(:writer)
      @writer.stub!(:write_passing)
      @writer.stub!(:write_failing)
      Kernel.stub!(:exit)
      @directory_reader = mock(:directory_reader)
      @directory_reader.stub!(:read_files).and_return({ "test.html" => "contents" })
      @test_suite_runner = TestSuiteRunner.new(@test_pusher, @writer, @directory_reader)
    end

    def new_test_suite_result status, summary
      test_suite_result = mock :"#{status.gsub(" ", "_")}_test_suite_result"
      test_suite_result.stub!(:status).and_return status
      test_suite_result.stub!(:summary).and_return summary
      test_suite_result.stub!(:completed_since).and_return([])
      test_suite_result
    end

    def new_in_progress_test_suite_result
      new_test_suite_result "in progress", "in progress summary"
    end

    def new_passed_test_suite_result
      new_test_suite_result "pass", "pass summary"
    end

    def new_failed_test_suite_result
      new_test_suite_result "fail", "fail summary"
    end

    def new_timeout_test_suite_result
      new_test_suite_result "timed out", "timed out summary"
    end

    it "reads a test" do
      @test_pusher.stub!(:push)
      @directory_reader.should_receive(:read_files).and_return(:file_body)
      @test_suite_runner.run_test_suite("foo_test", "test name")
    end

    it "pushes the test" do
      @test_pusher.should_receive(:push).with({:name => 'foo_test', :contents => { "test.html" => "contents" }.to_json })
      @test_suite_runner.run_test_suite("path/to/test", "foo_test")
    end

    context "timeout" do
      it 'returns a exit status of 2' do
        @test_pusher.stub!(:push).and_yield(new_timeout_test_suite_result)
        Kernel.should_receive(:exit).with(2)
        @test_suite_runner.run_test_suite("foo_test", "test name")
      end
    end

    context "failing test" do
      before do
        @test_pusher.stub!(:push).and_yield(new_failed_test_suite_result)
      end

      it "only writes once" do
        @writer.should_receive(:write_failing).once
        @test_suite_runner.run_test_suite("foo_test", "test name")
      end

      it "writes out an error code" do
        Kernel.should_receive(:exit).with(1)
        @test_suite_runner.run_test_suite("foo_test", "test name")
      end
    end

    context "passing test" do
      it "writes passing output" do
        @test_pusher.stub!(:push).and_yield(new_passed_test_suite_result)
        @writer.should_receive(:write_passing).with("pass summary")
        @test_suite_runner.run_test_suite("foo_test", "test name")
      end
    end

    context "server pusher raises exception" do
      before do
        @test_pusher.stub!(:push).and_raise("hell")
      end

      it "writes out the error" do
        @writer.should_receive(:write_failing).with("hell")
        @test_suite_runner.run_test_suite("foo_test", "test name")
      end

      it "exits with an error code" do
        Kernel.should_receive(:exit).with(1)
        @test_suite_runner.run_test_suite("foo_test", "test name")
      end
    end

    context "in progress" do
      it "writes nothing" do
        @test_pusher.stub!(:push).and_yield(new_in_progress_test_suite_result)
        @writer = mock(:writer)
        @writer.should_not_receive(:write_passing)
        @writer.should_not_receive(:write_failing)
        TestSuiteRunner.new(@test_pusher, @writer, @directory_reader).run_test_suite("foo_test", "test name")
      end
    end

    context "in progress, then passed result yielded" do
      it "only writes out the summary when the status is not 'in progress'" do
        in_progress_test_suite_result = new_in_progress_test_suite_result
        pass_test_suite_result        = new_passed_test_suite_result
        @test_pusher.stub!(:push).and_yield(in_progress_test_suite_result).and_yield(pass_test_suite_result)
        @writer.should_receive(:write_passing).with("pass summary").once
        @test_suite_runner.run_test_suite("foo_test", "test name")
      end
    end

    context "in progress twice then passed result yielded" do
      it "writes the difference between test results on each iteration" do
        in_progress_one = new_in_progress_test_suite_result
        in_progress_two = new_in_progress_test_suite_result
        @test_pusher.stub!(:push).and_yield(in_progress_one).and_yield(in_progress_two)

        in_progress_two.stub!(:completed_since).with(in_progress_one).and_return([
          mock(:status_one, :status => "pass", :device_id => "ipad", :test_name => "foo", :message => "test_suite_result"),
          mock(:status_one, :status => "fail", :device_id => "iphone", :test_name => "bar", :message => "test_suite_result")
        ])

        @writer.should_receive(:write_passing).with("PASS foo on ipad").once
        @writer.should_receive(:write_failing).with("FAIL bar on iphone").once

        @test_suite_runner.run_test_suite("foo bar", "test name")
      end
    end

    context "failed result yielded" do
      it "writes out the test message" do
        in_progress_one = new_in_progress_test_suite_result
        in_progress_two = new_in_progress_test_suite_result
        @test_pusher.stub!(:push).and_yield(in_progress_one).and_yield(in_progress_two)

        in_progress_two.stub!(:completed_since).with(in_progress_one).and_return([
          mock(:status_one, :status => "fail", :device_id => "iphone", :test_name => "bar", :message => "test result message")
        ])

        @writer.should_receive(:write_failing).with("test result message").once

        @test_suite_runner.run_test_suite("foo bar", "test name")
      end
    end
  end
end
