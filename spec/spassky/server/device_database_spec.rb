require "spassky/server/device_database"
require "ostruct"
require "fakefs/safe"

module Spassky::Server
  describe DeviceDatabase do
    before do
      WURFL.stub!(:new).and_return(nil)
      RestClient.stub!(:get)
      Kernel.stub!(:puts)
      FakeFS.activate!
    end

    after do
      FakeFS.deactivate!
    end

    context ".new" do
      it "loads up the wurfl database" do
        wurfl = mock(:wurfl).as_null_object
        WURFL.should_receive(:new).with("wurfl/wurfl-latest.xml.gz").and_return(wurfl)
        DeviceDatabase.new
      end

      it "tells the user that it is going to download a new wurfl database" do
        Kernel.should_receive(:puts).with("Downloading WURFL database")
        File.delete(Spassky::Server::WURFL_FILE)
        DeviceDatabase.new
      end

      it "downloads a new wurfl database if it doesn't exist" do
        File.delete(Spassky::Server::WURFL_FILE)
        RestClient.should_receive(:get).with(Spassky::Server::LATEST).and_return("file content")
        DeviceDatabase.new
        File.read(Spassky::Server::WURFL_FILE).should == "file content"
      end
    end

    describe ".device_identifier" do
      subject { DeviceDatabase.new }

      context "existing device" do
        it "returns the device identifier" do
          device = mock(:device)
          device.stub!(:model_name).and_return "MODEL"
          device.stub!(:id).and_return "ID"
          device.stub!(:mobile_browser).and_return "BROWSER"
          device.stub!(:device_os_version).and_return "OS_VERSION"
          wurfl = mock(:wurfl)
          wurfl.should_receive(:[]).and_return(device)
          WURFL.should_receive(:new).and_return(wurfl)
          subject.device_identifier("user agent").should == "MODEL (id = ID, mobile_browser = BROWSER, device_os_version = OS_VERSION)"
        end
      end

      context "device deosn't exist in the database" do
        it "returns user-agent" do
          wurfl = mock(:wurfl)
          wurfl.should_receive(:[]).and_return(nil)
          WURFL.stub!(:new).and_return(wurfl)
          subject.device_identifier("user agent").should == "user agent"
        end
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
