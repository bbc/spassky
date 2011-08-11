require 'spassky/test_runner'
require 'spassky/pusher'

module Spassky
  class Cli
    def self.run(argv)
      options = {}
      options[:colour] = true if argv.include?('--colour')
      TestRunner.new(Pusher.new(argv[0]), STDOUT, options).run_test(argv[1])
    end
  end
end
