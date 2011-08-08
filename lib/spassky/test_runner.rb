module Spassky
  class TestRunner
    def initialize(pusher) 
      @pusher = pusher
    end
    
    def run_test(test_name)
      file_contents = File.read(test_name)
      @pusher.push(:name => test_name, :contents => file_contents) do |result|
        Kernel.puts result.summary
      end
    end
  end
end