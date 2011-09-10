module Spassky::Server
  class DeviceList
    def initialize
      @devices_and_time_last_connected = {}
    end

    def update_last_connected device_id
      @devices_and_time_last_connected[device_id] = Time.now
    end

    def recently_connected_devices
      @devices_and_time_last_connected.keys.select do |device_id|
        recent? @devices_and_time_last_connected[device_id]
      end
    end

    def clear
      @devices_and_time_last_connected = {}
    end

    private

    def recent? time
      Time.now.to_f - time.to_f < 3
    end
  end
end
