module Spassky
  class RandomStringGenerator
    def self.random_string
      Time.now.to_i.to_s
    end
  end
end