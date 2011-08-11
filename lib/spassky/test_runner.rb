require 'rainbow'

module Spassky
  class TestRunner
    def initialize(pusher, output, options)
      @pusher = pusher
      @output = output
      @options = options
    end

    def run_test(test_name)
      file_contents = File.read(test_name)
      @pusher.push(:name => test_name, :contents => file_contents) do |result|
        if @options[:colour]
          @output.puts(result.summary.color(:red)) if result.status == 'fail'
          @output.puts(result.summary.color(:green)) if result.status == 'pass'
        else
          @output.puts result.summary
        end
        Kernel.exit(1) if result.status == 'fail'
      end
    end
  end
end
