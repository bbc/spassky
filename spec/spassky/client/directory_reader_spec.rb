require 'spassky/client/directory_reader'

module Spassky::Client
  describe DirectoryReader do
    def stub_file path
      File.stub!(:directory?).with(path).and_return(false)
      File.stub!(:file?).with(path).and_return(true)
    end

    def stub_directory path
      File.stub!(:directory?).with(path).and_return(true)
      File.stub!(:file?).with(path).and_return(false)
    end

    def add_file path, contents
      @all_paths  ||= []
      @all_paths << path
      stub_file path
      File.stub!(:read).with(path).and_return(contents)
    end

    def add_directory path
      @all_paths  ||= []
      @all_paths << path
      stub_directory path
    end

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
        stub_directory "directory"
        @all_paths = []
        Dir.stub!(:glob).and_return(@all_paths)
      end

      it "globs for files in the specified directory" do
        Dir.should_receive(:glob).with("directory/**/*").and_return([])
        DirectoryReader.new.read_files("directory")
      end

      it "returns a hash with all files in that directory" do
        add_file "directory/file1", "file 1 contents"
        add_file "directory/file2", "file 2 contents"
        DirectoryReader.new.read_files("directory").should == {
          "file1" => "file 1 contents",
          "file2" => "file 2 contents"
        }
      end

      it "recursively finds files in a sub-directory" do
        add_directory "directory/subdir"
        add_file "directory/subdir/file.html", "file 1 contents"
        add_file "directory/another_file.txt", "file 2 contents"

        DirectoryReader.new.read_files("directory").should == {
          "subdir/file.html" => "file 1 contents",
          "another_file.txt" => "file 2 contents"
        }
      end
    end
  end
end
