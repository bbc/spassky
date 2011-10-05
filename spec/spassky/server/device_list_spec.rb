require 'spec_helper'
require 'spassky/server/device_list'

module Spassky::Server
  describe DeviceList do
    subject { DeviceList.new }

    it "doesn't blow up when I get the recently connected devices" do
      subject.recently_connected_devices.should == []
    end

    it "keeps track of when devices last connected" do
      subject.update_last_connected("foo")
      subject.update_last_connected("bar")
      subject.recently_connected_devices.should == ["foo", "bar"]
    end

    it "clears all devices" do
      subject.update_last_connected("foo")
      subject.update_last_connected("bar")
      subject.clear
      subject.recently_connected_devices.size.should == 0
    end

    it "ignores devices connected more than 60 seconds ago" do
      now = Time.now
      Time.stub!(:now).and_return(now - 60)
      subject.update_last_connected("a")
      Time.stub!(:now).and_return(now - 59)
      subject.update_last_connected("b")
      Time.stub!(:now).and_return(now)
      subject.recently_connected_devices.should == ["b"]
    end

    it "supports timeouts set in the environment" do
      now = Time.now
      Time.stub!(:now).and_return(now - 30)
      subject.update_last_connected("a")
      Time.stub!(:now).and_return(now - 29)
      subject.update_last_connected("b")
      Time.stub!(:now).and_return(now)
      ENV["SPASSKY_TIMEOUT"] = "30"
      subject.recently_connected_devices.should == ["b"]
    end
  end
end
