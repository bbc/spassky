module Spassky::Client
  class DirectoryReader
    def read_files(pattern)
      if File.file? pattern
        { pattern => File.read(pattern) }
      elsif File.directory? pattern
        Dir.glob(pattern + "/*").inject({}) do |hash, path|
          hash[File.basename(path)] = File.read(path)
          hash
        end
      end
    end
  end
end
