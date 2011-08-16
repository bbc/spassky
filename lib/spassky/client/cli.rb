require 'spassky/client/test_runner'
require 'spassky/client/pusher'

module Spassky::Client
  class Cli
    def self.run(argv)
      writer = argv.include?('--colour') ? ColouredWriter : DefaultWriter
      TestRunner.new(Pusher.new(argv[0]), writer.new(STDOUT)).run_tests(argv[1])
    end
  end
end
