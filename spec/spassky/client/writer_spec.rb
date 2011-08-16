require 'spassky/client/writer'

module Spassky::Client
  describe DefaultWriter do
    it "writes failures in no colour" do
      output = mock(:output)
      output.should_receive(:puts).with("hello")
      DefaultWriter.new(output).write_failing("hello")
    end
    
    it "writes passes in no colour" do
      output = mock(:output)
      output.should_receive(:puts).with("hello")
      DefaultWriter.new(output).write_passing("hello")
    end
  end
  
  describe ColouredWriter do
    it "writes failures in red" do
      output = mock(:output)
      output.should_receive(:puts).with("\e[31mhello\e[0m")
      ColouredWriter.new(output).write_failing("hello")
    end
    
    it "writes passes in green" do
      output = mock(:output)
      output.should_receive(:puts).with("\e[32mhello\e[0m")
      ColouredWriter.new(output).write_passing("hello")
    end
  end
end