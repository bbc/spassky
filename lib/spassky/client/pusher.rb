require 'rest-client'
require 'spassky/test_result'

module Spassky::Client
  class Pusher
    def initialize(server_url, sleeper=Kernel)
      @server_url = server_url
      @sleeper = sleeper
    end
    
    def test_runs_url
      test_runs_url = @server_url.gsub(/\/$/, "") + "/test_runs"
    end
    
    def push(options)
      location = post_test(options)
      result = nil
      begin
        result = Spassky::TestResult.from_json(RestClient.get(location))
        yield result
        @sleeper.sleep 0.4 if result.status == 'in progress'
      end while result.status == 'in progress'
    end
    
    private
    
    def post_test(options)
      location = nil
      RestClient.post(test_runs_url, options) do |response, request, result|
        location = response.headers[:location]
      end
      raise "Expected #{test_runs_url} to respond with 302" unless location
      location
    end
  end
end