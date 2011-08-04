require 'spassky/test_runner'

module Spassky
  class Cli
    def self.run(argv)
      TestRunner.new.run_test(argv[0])
    end
  end
end