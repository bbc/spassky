require 'rest-client'
require 'spassky/test_suite_result'

module Spassky::Client
  class Pusher
    def initialize(server_url, sleeper=Kernel)
      @server_url = server_url
      @sleeper = sleeper
    end

    def push(options)
      each_test_suite_result(post_test(options)) do |result|
        yield result
        @sleeper.sleep 0.4
      end
    end

    private

    def each_test_suite_result location
      while (result = get_test_suite_result(location)).status == 'in progress'
        yield result
      end
      yield get_test_suite_result(location)
    end

    def get_test_suite_result location
      Spassky::TestSuiteResult.from_json(RestClient.get(location))
    end

    def test_runs_url
      test_runs_url = @server_url.gsub(/\/$/, "") + "/test_runs"
    end

    def post_test options
      RestClient.post(test_runs_url, options) do |response, request, result|
        process_test_post_response response
        get_redirect_location response
      end
    end

    def process_test_post_response response
      if response.code == 500
        raise response.to_str
      end
    end

    def get_redirect_location response
      location = response.headers[:location]
      raise "Expected #{test_runs_url} to respond with 302" unless location
      location
    end
  end
end
