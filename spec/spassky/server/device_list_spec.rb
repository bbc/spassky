require 'spec_helper'
require 'spassky/server/device_list'

module Spassky::Server
  describe DeviceList do
    it "keeps track of when devices last connected" do
      list = DeviceList.new
      list.update_last_connected("foo")
      list.update_last_connected("bar")
      list.recently_connected_devices.should == ["foo", "bar"]
    end
    
    it "clears all devices" do
      list = DeviceList.new
      list.update_last_connected("foo")
      list.update_last_connected("bar")
      list.clear
      list.recently_connected_devices.size.should == 0
    end
  end
end