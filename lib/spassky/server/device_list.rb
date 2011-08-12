module Spassky::Server
  class DeviceList
    def update_last_connected user_agent
      @devices_and_time_last_connected ||= {}
      @devices_and_time_last_connected[user_agent] = Time.now  
    end
    
    def recently_connected_devices
      @devices_and_time_last_connected.keys.select do |user_agent|
        Time.now.to_f - @devices_and_time_last_connected[user_agent].to_f < 3
      end
    end
    
    def clear
      @devices_and_time_last_connected = {}
    end
  end
end