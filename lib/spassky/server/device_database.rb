require "restclient"
require "wurfl-lite"
require "singleton"
require "fileutils"

module Spassky::Server
  LATEST = 'http://sourceforge.net/projects/wurfl/files/WURFL/2.2/wurfl-2.2.xml.gz/download'
  WURFL_DIRECTORY = File.join(File.dirname(__FILE__), "..", "..", "..", "wurfl")
  WURFL_FILE = File.join(WURFL_DIRECTORY, "wurfl-latest.xml.gz")

  class DeviceNotFoundError < StandardError
  end

  class DeviceDatabase
    def initialize
      download_wurfl_file unless File.exist?(WURFL_FILE)
      @wurfl = WURFL.new(WURFL_FILE)
    end

    def download_wurfl_file
      FileUtils.mkdir_p(WURFL_DIRECTORY)
      Kernel.puts("Downloading WURFL database")
      RestClient.proxy = ENV["http_proxy"] if ENV["http_proxy"]
      content = RestClient.get(LATEST)
      File.open(WURFL_FILE, "w") do |file|
        file.write(content)
      end
    end

    def device_identifier user_agent
      @stored_device_identifiers ||= {}

      unless @stored_device_identifiers[user_agent]
        device = @wurfl[user_agent]
        if device.nil?
          @stored_device_identifiers[user_agent] = user_agent
        else
          @stored_device_identifiers[user_agent] = "#{device.model_name} (id = #{device.id}, mobile_browser = #{device.mobile_browser}, device_os_version = #{device.device_os_version})"
        end
      end
      @stored_device_identifiers[user_agent]
    end

    def device user_agent
      @wurfl[user_agent]
    end
  end

  class SingletonDeviceDatabase < DeviceDatabase
    include Singleton
  end
end
