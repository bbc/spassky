require 'spassky/client/writer'

module Spassky::Client
  class TestRunner
    def initialize(pusher, writer, directory_reader)
      @pusher = pusher
      @writer = writer
      @directory_reader = directory_reader
    end

    def run_tests(pattern)
      previous_test_result = nil
      test_name = File.basename(pattern)
      @pusher.push(:name => test_name, :contents => @directory_reader.read_files(pattern).to_json) do |result|
        handle_test_result(previous_test_result, result)
        previous_test_result = result
      end
    end

    def handle_test_result(previous_test_result, test_result)
      write_in_progress_status previous_test_result, test_result
      unless test_result.status == "in progress"
        write(test_result.status, test_result.summary)
      end
      write_exit_code(test_result)
    end

    def write_in_progress_status previous_test_result, test_result
      test_result.completed_since(previous_test_result).each do |device_test_status|
        write(device_test_status.status, "#{device_test_status.status.upcase} #{device_test_status.test_name} on #{device_test_status.user_agent}")
      end
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
