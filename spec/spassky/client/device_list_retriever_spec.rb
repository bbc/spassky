require 'spec_helper'

module Spassky::Client
  describe DeviceListRetriever do
    it "retrieves the device list from the server" do
      devices = ["iphone", "nokia"]
      RestClient.should_receive(:get).with("http://localhost:9292/devices/list").and_return(devices.to_json)
      DeviceListRetriever.new("http://localhost:9292").get_connected_devices
    end

    it "returns a list of devices" do
      devices = ["iphone", "nokia"]
      RestClient.stub(:get).and_return(devices.to_json)
      returned_devices = DeviceListRetriever.new("http://localhost:9292").get_connected_devices
      returned_devices.should == devices
    end
  end
end
