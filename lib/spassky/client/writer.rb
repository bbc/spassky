require 'rainbow'

module Spassky::Client
  class DefaultWriter
    def initialize(output)
      @output = output
    end
    
    def write_passing(text)
      @output.puts text
    end
    
    def write_failing(text)
      @output.puts text
    end
  end
  
  class ColouredWriter
    def initialize(output)
      @output = output
    end
    
    def write_passing(text)
      @output.puts text.color(:green)
    end
    
    def write_failing(text)
      @output.puts text.color(:red)
    end
  end
end