module Hickey
  module DomainDetector
    module Scopes
      def self.included(base)
        base.send(:alias_method_chain, :visit_hash, :scopes)
        base.send(:alias_method_chain, :new_instance, :scopes)
      end
      
      def visit_hash_with_scopes(attribute, record)
        scopes.each do |foreign_key, owner|
          record[foreign_key] = owner.id unless record[foreign_key]
        end
        returning visit_hash_without_scopes(attribute, record) do |instance|
          scopes.delete instance.class.name.foreign_key
        end
      end
      
      def new_instance_with_scopes(class_or_instance, record)
        returning new_instance_without_scopes(class_or_instance, record) do |instance|
          scopes[instance.class.name.foreign_key] = instance
        end
      end
      
      private
      def scopes
        @scopes ||= {}
      end
    end
  end
end
