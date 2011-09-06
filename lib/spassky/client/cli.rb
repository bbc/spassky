require 'spassky'
require 'spassky/version'
require 'spassky/server/app'
require 'spassky/client/device_list_retriever'
require 'spassky/client/test_runner'
require 'spassky/client/pusher'
require 'spassky/client/directory_reader'
require 'commandable'

module Spassky::Client
  class Cli
    extend Commandable

    DEFAULT_PORT = "9191"
    DEFAULT_SERVER = "http://localhost:#{DEFAULT_PORT}"

    command "run a test"
    def run(test, server = DEFAULT_SERVER, colour = false)
      writer = colour ? ColouredWriter : DefaultWriter
      pusher = Pusher.new(server)
      test_runner = TestRunner.new(pusher, writer.new(STDOUT), DirectoryReader.new(test))
      test_runner.run_tests(test)
    end

    command "list devices"
    def devices(server = DEFAULT_SERVER)
      Spassky::Client::DeviceListRetriever.new(server).get_connected_devices.each do |device|
        puts device
      end
      nil
    end

    command "run the spassky server"
    def server(port = DEFAULT_PORT)
      Spassky::Server::App.set :port, port
      Spassky::Server::App.run!
    end
  end
end
