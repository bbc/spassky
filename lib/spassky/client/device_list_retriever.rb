require 'restclient'

module Spassky::Client
  class DeviceListRetriever
    def initialize(url)
      @url = url
    end

    def get_connected_devices
      JSON.parse(RestClient.get(@url + "/devices/list"))
    end
  end
end
