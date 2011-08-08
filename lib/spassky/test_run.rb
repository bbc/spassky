module Spassky
  class TestRun
    attr_accessor :name, :contents, :id
    
    def initialize(options)
      name = options[:name]
      contents = options[:contents]
      self.id = 123
      @status_by_user_agent = {}
    end
    
    def run_by_user_agent?(user_agent)
      !@status_by_user_agent[user_agent].nil?
    end
    
    def save_results_for_user_agent(options)
      @status_by_user_agent[options[:user_agent]] = options[:status]
    end
    
    def status
      @status_by_user_agent.size == 0 ? "in progress" : @status_by_user_agent[@status_by_user_agent.keys.first]
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
    
    def self.find_next_to_run_for_user_agent(user_agent)
      @test_runs.find { |test_run| test_run.run_by_user_agent?(user_agent) == false }
    end
    
    def self.delete_all
      @test_runs = []
    end
  end
end