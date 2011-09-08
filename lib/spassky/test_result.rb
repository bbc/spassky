require 'spassky/test_result_summariser'
require 'spassky/device_test_status'
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

    def completed_since(older_test_result)
      if older_test_result.nil?
        device_statuses.select { |s| s.completed? }
      else
        find_newly_completed_device_results(older_test_result)
      end
    end

    def summary
      TestResultSummariser.new(@device_statuses).summary
    end

    def to_json
      {
        :status => "pass",
        :device_statuses => @device_statuses.map do |status|
          {
            :device_id => status.device_id,
            :test_name => status.test_name,
            :status => status.status,
            :message => status.message
          }
        end
      }.to_json
    end

    def self.from_json json
      parsed = JSON.parse(json)
      test_result = TestResult.new(
        parsed['device_statuses'].map do |t|
        [:device_id, :test_name, :status, :message].map do |name|
        end
          DeviceTestStatus.new({:device_id => t["device_id"], :test_name => t["test_name"], :status => t["status"], :message => t["message"]})
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
end
