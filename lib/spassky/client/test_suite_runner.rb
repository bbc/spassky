require 'spassky/client/writer'

module Spassky::Client
  class TestSuiteRunner
    def initialize(pusher, writer, directory_reader)
      @pusher = pusher
      @writer = writer
      @directory_reader = directory_reader
    end

    def run_test_suite(pattern, test_name)
      begin
        @pusher.push(:name => test_name, :contents => @directory_reader.read_files.to_json) do |result|
          handle_test_suite_result(result)
        end
      rescue => error
        @writer.write_failing(error.message)
        Kernel.exit(1)
      end
    end

    private

    def handle_test_suite_result(test_suite_result)
      write_in_progress_status test_suite_result
      unless test_suite_result.status == "in progress"
        write(test_suite_result.status, test_suite_result.summary)
      end
      @previous_test_suite_result = test_suite_result
      write_exit_code(test_suite_result)
    end

    def write_in_progress_status test_suite_result
      test_suite_result.completed_since(@previous_test_suite_result).each do |device_test_status|
        write_completed_test_status device_test_status
      end
    end

    def write_completed_test_status device_test_status
      write(device_test_status.status, completion_status(device_test_status))
      write(device_test_status.status, device_test_status.message)
    end

    def completion_status device_test_status
      "#{device_test_status.status.upcase} #{device_test_status.test_name} on #{device_test_status.device_id}"
    end

    def write status, message
      method = status == 'pass' ? :write_passing : :write_failing
      @writer.send(method, message)
    end

    def write_exit_code(result)
      Kernel.exit(1) if result.status == 'fail'
      Kernel.exit(2) if result.status == 'timed out'
    end
  end
end
