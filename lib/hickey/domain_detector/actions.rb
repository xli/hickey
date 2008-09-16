module Hickey
  module DomainDetector
    module Actions
      def self.included(base)
        base.send(:alias_method_chain, :visit_hash, :find_or_create_actions)
      end
      
      def visit_hash_with_find_or_create_actions(attribute, record)
        case record.keys.first
        when :find
          record = record[:find]
          attribute = find_action(attribute, record)
        when :create
          record = record[:create]
        when :find_or_create
          record = record[:find_or_create]
          if find_attribute = find_action(attribute, record)
            attribute = find_attribute
          end
        end
        visit_hash_without_find_or_create_actions(attribute, record)
      end
      
      def find_action(attribute, record)
        conditions = record.inject({}) do |c, entity|
          key, value = entity
          unless [Hash, Array].include?(value.class)
            c[key] = value
          end
          c
        end
        compute_type(attribute, record).find(:first, :conditions => conditions)
      end
    end
  end
end
