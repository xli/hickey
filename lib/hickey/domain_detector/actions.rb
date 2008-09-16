module Hickey
  module DomainDetector
    module Actions
      
      module Find
        def self.included(base)
          base.send(:alias_method_chain, :visit_hash, :find_action)
        end
        
        def visit_hash_with_find_action(attribute, record)
          if record.keys.first == :find
            record = record[:find]
            conditions = record.inject({}) do |c, entity|
              key, value = entity
              unless [Hash, Array].include?(value.class)
                c[key] = value
              end
              c
            end
            attribute = compute_type(attribute, record).find(:first, :conditions => conditions)
          end
          visit_hash_without_find_action(attribute, record)
        end
      end
      
      module Create
        def self.included(base)
          base.send(:alias_method_chain, :visit_hash, :create_action)
        end
        
        def visit_hash_with_create_action(attribute, record)
          if record.keys.first == :create
            record = record[:create]
          end
          visit_hash_without_create_action(attribute, record)
        end
      end
      
    end
  end
end
