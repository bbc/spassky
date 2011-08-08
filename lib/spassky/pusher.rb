require 'rest-client'
require 'spassky/test_result'

module Spassky
  class Pusher
    def initialize(server_url, sleeper=Kernel)
      @server_url = server_url
      @sleeper = sleeper
    end
    
    def test_runs_url
      test_runs_url = @server_url.gsub(/\/$/, "") + "/test_runs"
    end
    
    def push(options)
      location = nil
      RestClient.post(test_runs_url, options) do |response, request, result|
        location = response.headers[:location]
      end
      raise "Expected #{test_runs_url} to respond with 302" unless location
      yield wait(location)
    end
    
    def wait(location)
      result = nil
      begin
        result = TestResult.from_json(RestClient.get(location))
        @sleeper.sleep 0.4 if result.status == 'in progress'
      end while result.status == 'in progress'
      result
    end
  end
end