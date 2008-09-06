
module Hickey
  module Timestamp
    def attach_timestamps
      if record_timestamps
        t = self.class.default_timezone == :utc ? Time.now.utc : Time.now
        write_attribute('created_at', t) if respond_to?(:created_at) && created_at.nil?
        write_attribute('created_on', t) if respond_to?(:created_on) && created_on.nil?

        write_attribute('updated_at', t) if respond_to?(:updated_at)
        write_attribute('updated_on', t) if respond_to?(:updated_on)
      end
    end
  end
end

ActiveRecord::Base.send(:include, Hickey::Timestamp)
