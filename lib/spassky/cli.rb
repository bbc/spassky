require 'spassky/test_runner'
require 'spassky/pusher'

module Spassky
  class Cli
    def self.run(argv)
      TestRunner.new(Pusher.new(argv[0])).run_test(argv[1])
    end
  end
end