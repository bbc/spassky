require 'spassky/test_result'

module Spassky::Server
  class TestRun
    attr_accessor :name, :contents, :id

    def initialize(options)
      @name = options[:name]
      @contents = options[:contents]
      @status_by_device_id = {}
      (options[:devices] || []).each do |device|
        @status_by_device_id[device] = "in progress"
      end
    end

    def run_by_device_id?(device_id)
      @status_by_device_id[device_id] != "in progress"
    end

    def save_result_for_device(options)
      unless ['pass', 'fail'].include? options[:status]
        raise "#{options[:status]} is not a valid status"
      end
      @status_by_device_id[options[:device_identifier]] = options[:status]
    end

    def update_connected_devices(device_ids)
      @status_by_device_id.each do |device_id, status|
        if !device_ids.include?(device_id) && status == "in progress"
          @status_by_device_id[device_id] = "timed out"
        end
      end
    end

    def result
      Spassky::TestResult.new(@status_by_device_id.map { |device_id, status|
        Spassky::DeviceTestStatus.new(device_id, status, name)
      })
    end

    def self.create(options)
      new_test_run = TestRun.new(options)
      new_test_run.id = test_runs.size
      test_runs << new_test_run
      new_test_run
    end

    def self.find(id)
      test_runs.find { |test_run| test_run.id.to_s == id.to_s  }
    end

    def self.find_next_test_to_run_by_device_id(device_id)
      test_runs.find { |test_run| test_run.run_by_device_id?(device_id) == false }
    end

    def self.delete_all
      @test_runs = []
    end

    def self.test_runs
      @test_runs ||= []
    end
  end
end
