require "spassky/server/device_database"
require "ostruct"

module Spassky::Server
  describe DeviceDatabase do
    before do
      WURFL.stub!(:new).and_return(nil)
    end

    context ".new" do
      it "loads up the wurfl database" do
        wurfl = mock(:wurfl).as_null_object
        WURFL.should_receive(:new).with("wurfl/wurfl.xml").and_return(wurfl)
        DeviceDatabase.new
      end
    end

    context "request device that exists" do
      it "returns a device" do
        wurfl = mock :wurfl
        device = mock :device
        wurfl.stub!(:[]).and_return(device)
        WURFL.stub!(:new).and_return(wurfl)
        DeviceDatabase.new.device("user agent").should == (device)
      end
    end
  end
end
