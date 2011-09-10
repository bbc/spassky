module Spassky
  class TestSuiteResultSummariser
    def initialize device_statuses
      @device_statuses = device_statuses
    end

    def summary
      statuses = []
      {"pass" => "passed", "fail" => "failed", "timed out" => "timed out"}.each do |status, description|
        status_count = status_count status
        if status_count > 0
          statuses << "#{status_count} #{description}"
        end
      end
      statuses.join ", "
    end

    def status_count status
      @device_statuses.find_all { |device_status| device_status.status == status }.size
    end
  end
end
