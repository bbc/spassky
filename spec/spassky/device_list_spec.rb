require 'spec_helper'
require 'spassky/device_list'

module Spassky
  describe DeviceList do
    it "keeps track of when devices last connected" do
      list = DeviceList.new
      list.update_last_connected("foo")
      list.update_last_connected("bar")
      list.recently_connected_devices.should == ["foo", "bar"]
    end

  end
end