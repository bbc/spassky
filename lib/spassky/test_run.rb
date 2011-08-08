module Spassky
  class TestRun
    attr_accessor :name, :contents, :id
    
    def initialize(options)
      name = options[:name]
      contents = options[:contents]
      self.id = 123
    end
    
    def self.create(options)
      new_test_run = TestRun.new(options)
      @test_runs ||= []
      @test_runs << new_test_run
      new_test_run
    end

    def self.find(id)
      @test_runs.last
    end
  end
end