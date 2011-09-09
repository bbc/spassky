module Spassky
  class DeviceTestStatus
    attr_accessor :device_id, :test_name, :status, :message

    def initialize(options = {})
      @device_id = options[:device_id]
      @test_name = options[:test_name]
      @status = options[:status]
      @message = options[:message]
    end

    def in_progress?
      @status == "in progress"
    end

    def completed?
      @status != "in progress"
    end
  end
end