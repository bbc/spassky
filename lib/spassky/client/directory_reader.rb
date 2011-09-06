module Spassky::Client
  class DirectoryReader

    def initialize(pattern)
      @pattern = pattern
    end

    def read_directory

    end


    def read_files
      if File.file? @pattern
        { @pattern => File.read(@pattern) }
      elsif File.directory? @pattern
        Dir.glob(@pattern + "/**/*").inject({}) do |hash, path|
          if File.file? path
            key = path.gsub(/^#{@pattern}\//, "")
            hash[key] = File.read(path)
          end
          hash
        end
      end
    end
  end
end
