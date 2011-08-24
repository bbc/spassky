require 'json'

module Spassky
  class TestResult
    attr_reader :device_statuses
    def initialize device_statuses
      @device_statuses = device_statuses
    end

    def status
      statuses = @device_statuses.map { |s| s.status }.uniq
      return "in progress" if statuses.include?("in progress") || statuses.size == 0
      return "fail" if statuses.include?("fail")
      return "timed out" if statuses.include?("timed out")
      "pass"
    end

    def count_fails
      @device_statuses.count { |s| s.status == "fail" }
    end

    def count_timeouts
      @device_statuses.count { |s| s.status == "timed out" }
    end

    def completed_since(older_test_result)
      if older_test_result.nil?
        device_statuses.select { |s| s.completed? }
      else
        find_newly_completed_device_results(older_test_result)
      end
    end

    def summary
      result = "?"
      count = @device_statuses.size
      if count_timeouts > 0
        result = "1 test timed out on #{count} device"
      else
        status = "passed"
        fail_count = count_fails
        if fail_count > 0
          status = "failed"
          count = fail_count
        end
        result = "1 test #{status} on #{count} device"
      end
      result << "s" if @device_statuses.size > 1
      return result
    end

    def to_json
      {
        :status => "pass",
        :device_statuses => @device_statuses.map do |status|
          {
            :user_agent => status.user_agent,
            :status => status.status,
            :test_name => status.test_name
          }
        end
      }.to_json
    end

    def self.from_json json
      parsed = JSON.parse(json)
      test_result = TestResult.new(
        parsed['device_statuses'].map do |t|
          DeviceTestStatus.new(t["user_agent"], t["status"], t["test_name"])
        end
      )
    end

    private

    def find_newly_completed_device_results(older_test_result)
      completed = []
      before_and_after(older_test_result) do |before, after|
        if before.in_progress? && after.completed?
          completed << after
        end
      end
      completed
    end

    def before_and_after(older_test_result)
      device_statuses.each_with_index do |s, i|
        yield older_test_result.device_statuses[i], s
      end
    end
  end

  class DeviceTestStatus
    attr_reader :user_agent, :status, :test_name

    def initialize(user_agent, status, test_name)
      @user_agent = user_agent
      @status = status
      @test_name = test_name
    end

    def in_progress?
      @status == "in progress"
    end

    def completed?
      @status != "in progress"
    end
  end
end
