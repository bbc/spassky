module Spassky
  class TestRunner
    def initialize(pusher) 
      @pusher = pusher
    end
    
    def run_test(test_name)
      file_contents = File.read(test_name)
      @pusher.push(file_contents) do |result|
        Kernel.puts "1 test #{result}ed"
      end
    end
  end
end