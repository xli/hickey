module Hickey
  module DomainDetector
    module Configurable
      def self.included(base)
        base.class_eval do
          @@configurations = {}
          cattr_accessor :configurations, :instance_writer => false
          alias_method_chain :new_instance, :configuration
        end
      end
      
      private
      def new_instance_with_configuration(class_or_instance, record)
        instance = new_instance_without_configuration(class_or_instance, record)
        instance.instance_eval do
          def valid_without_callbacks?
            true
          end
        end
        unless configuration_of(instance)[:callbacks] == :all
          instance.instance_eval do
            def callback(*args)
              true
            end
          end
        end
        instance
      end
      
      def configuration_of(instance)
        klass = instance.class
        @@configurations[klass.name.underscore.to_sym] || @@configurations[klass.base_class.name.underscore.to_sym] || {}
      end
    end
  end
end