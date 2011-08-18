require 'spassky/client/device_list_retriever'
require 'spassky/client/test_runner'
require 'spassky/client/pusher'
require 'spassky/client/directory_reader'

module Spassky::Client
  class Cli
    def self.run(argv)
      if argv[1] == "devices"
        DeviceListRetriever.new(argv[0]).get_connected_devices.each do |device|
          puts device
        end
      else
        writer = argv.include?('--colour') ? ColouredWriter : DefaultWriter
        TestRunner.new(Pusher.new(argv[0]), writer.new(STDOUT), DirectoryReader.new).run_tests(argv[1])
      end
    end
  end
end
