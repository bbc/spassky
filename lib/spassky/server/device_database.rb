require "wurfl-lite"
require "singleton"

module Spassky::Server
  class DeviceNotFoundError < StandardError
  end

  class DeviceDatabase
    def initialize
      @wurfl = WURFL.new("wurfl/wurfl.xml")
    end

    def device user_agent
      @wurfl[user_agent]
    end
  end

  class SingletonDeviceDatabase < DeviceDatabase
    include Singleton
  end
end
