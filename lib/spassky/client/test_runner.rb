require 'rainbow'

module Spassky::Client
  class TestRunner
    def initialize(pusher, output, options)
      @pusher = pusher
      @output = output
      @options = options
    end

    def run_test(test_name)
      file_contents = File.read(test_name)
      @pusher.push(:name => test_name, :contents => file_contents) do |result|
        write_output result
        Kernel.exit(1) if result.status == 'fail'
        Kernel.exit(2) if result.status == 'timed out'
      end
    end

    def write_output test_result
      colour = :default
      if @options[:colour]
        colour = test_result.status == 'pass' ? :green : :red
        @output.puts test_result.summary.color(colour)
      else
        @output.puts test_result.summary
      end
    end
  end
end
