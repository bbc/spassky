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
        Time.now.to_f - @devices_and_time_last_connected[device_id].to_f < 3
      end
    end

    def clear
      @devices_and_time_last_connected = {}
    end
  end
end
