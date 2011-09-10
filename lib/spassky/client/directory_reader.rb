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
      Dir.glob(@pattern + "/**/*").inject({}) do |hash, path|
        if File.file? path
          hash[remove_pattern_from_file(path)] = File.read(path)
        end
        hash
      end
    end

    def remove_pattern_from_file path
      path.gsub(/^#{@pattern}\//, "")
    end

    def read_file
      { @pattern => File.read(@pattern) }
    end
  end
end
