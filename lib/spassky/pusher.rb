require 'rest-client'

module Spassky
  class Pusher
    attr_accessor :server_url
    
    def initialize(server_url)
      @server_url = server_url
    end
    def push(test_contents)
      location = nil
      RestClient.post(server_url, test_contents) do |response, request, result|
        location = response.headers["location"]
      end
      RestClient.get(location)
      RestClient.get(location)
      RestClient.get(location)
      RestClient.get(location)
    end
  end
end