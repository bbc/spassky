require "spassky/device_test_status"

FactoryGirl.define do
  factory :device_test_status, :class => Spassky::DeviceTestStatus do
    sequence :device_id do |number|
      "agent#{number}"
    end
    test_name "test"
    status "pass"
    message "test message"
  end
end
