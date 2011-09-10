module Spassky::Client
  class DirectoryReader
    def initialize(pattern)
      @pattern = pattern
    end

    def read_files
      if File.file? @pattern
        read_file
      elsif File.directory? @pattern
        read_directory
      end
    end

    private

    def read_directory
      files = {}
      Dir.glob(@pattern + "/**/*").each do |path|
        if File.file? path
          files[remove_pattern_from_file(path)] = File.read(path)
        end
      end
      files
    end

    def remove_pattern_from_file path
      path.gsub(/^#{@pattern}\//, "")
    end

    def read_file
      { @pattern => File.read(@pattern) }
    end
  end
end
