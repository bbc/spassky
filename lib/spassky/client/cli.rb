require 'spassky'
require 'spassky/version'
require 'spassky/server/app'
require 'spassky/client/device_list_retriever'
require 'spassky/client/test_suite_runner'
require 'spassky/client/pusher'
require 'spassky/client/directory_reader'

module Spassky::Client
  class Cli
    DEFAULT_PORT = "9191"
    DEFAULT_SERVER = "http://localhost:#{DEFAULT_PORT}"

    def run(pattern, test, server = DEFAULT_SERVER, colour = FALSE)
      writer = colour ? ColouredWriter : DefaultWriter
      pusher = Pusher.new(server)
      test_suite_runner = TestSuiteRunner.new(pusher, writer.new(STDOUT), DirectoryReader.new(pattern))
      test_suite_runner.run_test_suite(pattern, test)
    end

    def devices(server = DEFAULT_SERVER)
      Spassky::Client::DeviceListRetriever.new(server).get_connected_devices.each do |device|
        puts device
      end
      nil
    end

    def server(port = DEFAULT_PORT)
      Spassky::Server::App.set :port, port
      Spassky::Server::App.run!
    end
  end
end
