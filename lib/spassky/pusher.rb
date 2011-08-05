require 'rest-client'

module Spassky
  class Pusher
    def initialize(server_url, sleeper=Kernel)
      @server_url = server_url
      @sleeper = sleeper
    end
    
    def test_runs_url
      test_runs_url = @server_url.gsub(/\/$/, "") + "/test_runs"
    end
    
    def push(test_contents)
      location = nil
    
      RestClient.post(test_runs_url, test_contents) do |response, request, result|
        location = response.headers[:location]
      end
      raise "Expected #{test_runs_url} to respond with 302" unless location
      yield wait(location)
    end
    
    def wait(location)
      while (outcome = RestClient.get(location)) == 'in progress'
        @sleeper.sleep 0.4
      end
      outcome
    end
  end
end