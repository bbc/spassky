module Spassky
  class TestSuiteResultSummariser
    def initialize device_statuses
      @device_statuses = device_statuses
    end

    def summary
      statuses = []
      statuses << "#{status_count("pass")} passed" if status_count("pass") > 0
      statuses << "#{status_count("fail")} failed" if status_count("fail") > 0
      statuses << "#{status_count("timed out")} timed out" if status_count("timed out") > 0
      statuses.join ", "
    end

    def status_count status
      @device_statuses.find_all { |device_status| device_status.status == status }.size
    end
  end
end
