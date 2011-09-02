module Spassky
  class TestResultSummariser
    def initialize device_statuses
      @device_statuses = device_statuses
    end

    def summary
      statuses = []
      passes = status_count "pass"
      fails = status_count "fail"
      timeouts = status_count "timed out"
      statuses << "#{passes} passed" if passes > 0
      statuses << "#{fails} failed" if fails > 0
      statuses << "#{timeouts} timed out" if timeouts > 0
      statuses.join ", "
    end

    def status_count status
      @device_statuses.find_all { |device_status| device_status.status == status }.size
    end
  end
end
