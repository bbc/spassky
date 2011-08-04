module Spassky
  class TestRunner
    def initialize(pusher) 
      @pusher = pusher
    end
    
    def run_test(test_name)
      file_contents = File.read(test_name)
      @pusher.push(file_contents) do
        Kernel.puts "1 test passed"
      end
    end
  end
end