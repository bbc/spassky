require "spec_helper"
require "spassky/server/test_suite_container"

module Spassky::Server
  describe TestSuiteContainer do
    before do
      @test_contents = {
        "test_file.js"        => "some javascript",
        "fake_test.html.file" => "don't choose this one",
        "test_name.html"      => "actual test!",
        "directory/another_directory/filename.txt" => "file 1 contents",
        "example_test.html"   => "</head>"
      }
    end

    context "file name is a file" do
      it "returns the specified file" do
        TestSuiteContainer.new(@test_contents, nil, "", nil).get_file("test_file.js").should == "some javascript"
      end
    end

    context "with a file that is in a subdirectory" do
      it "returns the file" do
        TestSuiteContainer.new(@test_contents, nil, "", nil).get_file("directory/another_directory/filename.txt").should == "file 1 contents"
      end
    end

    describe "when the test contents includes a </head> tag" do
      it "adds a meta-refresh tag to the test contents" do
        url = "http://example.org"
        seconds = 23
        TestSuiteContainer.new(@test_contents, url, "", seconds).get_file("example_test.html").should include "<meta http-equiv=\"refresh\" content=\"#{seconds}; url='#{url}'\"></head>"
      end

      it "adds the assert.js script to the head" do
        File.stub!(:read).and_return("assert.js!")
        TestSuiteContainer.new(@test_contents, nil, "", nil).get_file("example_test.html").should include "<script type=\"text/javascript\">assert.js!</script>"
      end

      it "injects the assert post back url into assert.js" do
        File.stub!(:read).and_return("assert.js! {ASSERT_POST_BACK_URL}")
        TestSuiteContainer.new(@test_contents, nil, "http://assert.org", nil).get_file("example_test.html").should include "assert.js! http://assert.org"
      end
    end
  end
end
