
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
  
  module Reflection
    def self.included(base)
      base.extend(ClassMethods)
      class <<base
        alias_method_chain :create_reflection, :caching_reflection_instance
      end
    end
    
    module ClassMethods
      def __reflection__
        @__reflection__ ||= {}
      end
      
      def create_reflection_with_caching_reflection_instance(macro, name, options, active_record, &block)
        returning create_reflection_without_caching_reflection_instance(macro, name, options, active_record, &block) do |reflection|
          __reflection__[name] = reflection
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Hickey::Timestamp)
ActiveRecord::Base.send(:include, Hickey::Reflection)
