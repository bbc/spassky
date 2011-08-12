module Spassky::Server
  class DeviceList
    def update_last_connected user_agent
      @devices ||= {}
      @devices[user_agent] = true   
    end
    
    def recently_connected_devices
      @devices.keys
    end
    
    def clear
      @devices = {}
    end
  end
end