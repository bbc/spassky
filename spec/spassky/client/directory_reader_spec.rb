require 'spassky/client/directory_reader'

module Spassky::Client
  describe DirectoryReader do
    context "when given a file name" do
      it "returns a hash with one file" do
        File.should_receive(:file?).and_return(true)
        File.should_receive(:read).with("foo").and_return("content")
        DirectoryReader.new.read_files("foo").should == {
          "foo" => "content"
        }
      end
    end
    context "when given a directory name" do
      before do
        File.stub!(:directory?).with("directory").and_return(true)
      end

      it "globs for files in the specified directory" do
        File.stub!(:file?).and_return(false)
        File.stub!(:directory?).and_return(true)
        Dir.should_receive(:glob).with("directory/*").and_return([])
        DirectoryReader.new.read_files("directory")
      end

      it "returns a hash with all files in that directory" do
        File.stub!(:file?).and_return(false)
        File.stub!(:directory?).and_return(true)
        Dir.stub!(:glob).and_return ["directory/file1", "directory/file2"]
        File.stub!(:read).with("directory/file1").and_return("file 1 contents")
        File.stub!(:read).with("directory/file2").and_return("file 2 contents")
        DirectoryReader.new.read_files("directory").should == {
          "file1" => "file 1 contents",
          "file2" => "file 2 contents"
        }
      end

      it "recursively finds files in a sub-directory" do
        Dir.stub!(:glob).and_return [
          "dir/subdir/file.rb",
          "dir/subdir",
          "dir/another_file.rb"
        ]

        File.stub!(:file?).with("dir/subdir/file.rb").and_return true
        File.stub!(:file?).with("dir/subdir").and_return false
        File.stub!(:file?).with("dir/another_file.rb").and_return true

        File.stub!(:directory?).with("dir/subdir/file.rb").and_return false
        File.stub!(:directory?).with("dir/subdir").and_return true
        File.stub!(:directory?).with("dir/another_file.rb").and_return false

        File.stub!(:read).with("dir/subdir/file.rb").and_return("file 1 contents")
        File.stub!(:read).with("dir/another_file.rb").and_return("file 2 contents")

        DirectoryReader.new.read_files("directory").should == {
          "dir/subdir/file.rb" => "file 1 contents",
          "dir/another_file.rb" => "file 2 contents"
        }
      end
    end
  end
end
