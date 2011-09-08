module Spassky
  class DeviceTestStatus
    attr_reader :device_id, :status, :test_name, :message

    def initialize(options)
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
