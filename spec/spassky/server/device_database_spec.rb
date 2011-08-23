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

      it "tells the user that  it is going to download a new wurfl database" do
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
