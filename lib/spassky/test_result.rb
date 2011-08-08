require 'json'

module Spassky
  class TestResult
    attr_reader :device_statuses
    def initialize device_statuses
      @device_statuses = device_statuses
    end
    
    def status
      statuses = @device_statuses.map { |s| s.status }.uniq
      return "in progress" if statuses.include?("in progress") || statuses.size == 0
      return "fail" if statuses.include?("fail")
      "pass"
    end
    
    def summary
      count = @device_statuses.size
      status = "passed"
      fail_count = @device_statuses.count { |s| s.status == "fail" }
      if fail_count > 0
        status = "failed"
        count = fail_count
      end
      result = "1 test #{status} on #{count} device"
      result << "s" if @device_statuses.size > 1
      result
    end
    
    def to_json
      {
        :status => "pass",
        :device_statuses => @device_statuses.map do |status|
          {
            :user_agent => status.user_agent,
            :status => status.status
          }
        end
      }.to_json
    end
    
    def self.from_json json
      parsed = JSON.parse(json)
      test_result = TestResult.new(
        parsed['device_statuses'].map do |t|
          DeviceTestStatus.new(t["user_agent"], t["status"])
        end
      )
    end
  end
  
  class DeviceTestStatus
    attr_reader :user_agent, :status
    
    def initialize user_agent, status
      @user_agent = user_agent
      @status = status
    end
  end
end