require 'rest-client'

module Spassky
  class Pusher
    attr_accessor :server_url
    
    def initialize(server_url, sleeper=Kernel)
      @server_url = server_url
      @sleeper = sleeper
    end
    
    def push(test_contents)
      location = nil
      RestClient.post(server_url, test_contents) do |response, request, result|
        location = response.headers["location"]
      end
      outcome = nil
      while (outcome = RestClient.get(location)) == 'in progress'
        @sleeper.sleep 0.4
      end
      yield outcome
    end
  end
end