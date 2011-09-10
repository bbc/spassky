require 'spassky/test_suite_result_summariser'
require 'spassky/device_test_status'
require 'json'

module Spassky
  class TestSuiteResult
    attr_reader :device_statuses
    def initialize device_statuses
      @device_statuses = device_statuses
    end

    def status
      statuses = @device_statuses.map { |s| s.status }.uniq
      return "in progress" if statuses.size == 0
      status = ["in progress", "fail", "timed out"].find {|s| statuses.include? s}
      return status if status
      "pass"
    end

    def completed_since(older_test_suite_result)
      if older_test_suite_result.nil?
        device_statuses.select { |s| s.completed? }
      else
        find_newly_completed_device_results(older_test_suite_result)
      end
    end

    def summary
      TestSuiteResultSummariser.new(@device_statuses).summary
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
      device_test_statuses = JSON.parse(json)['device_statuses'].map do |device_test_status|
        DeviceTestStatus.from_hash(device_test_status)
      end
      test_suite_result = TestSuiteResult.new(device_test_statuses)
    end

    private

    def find_newly_completed_device_results(older_test_suite_result)
      completed = []
      before_and_after(older_test_suite_result) do |before, after|
        if before.in_progress? && after.completed?
          completed << after
        end
      end
      completed
    end

    def before_and_after(older_test_suite_result)
      device_statuses.each_with_index do |s, i|
        yield older_test_suite_result.device_statuses[i], s
      end
    end
  end
end
