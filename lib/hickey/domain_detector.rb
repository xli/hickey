module Hickey
  class DomainDetector
    
    def connection
      ActiveRecord::Base.connection
    end
    
    def visit(domain)
      r = {}
      domain.each do |key, value|
        r[key] = value.accept_for_hickey(key, self)
      end
      r.size == 1 ? r.values.first : r
    end
    
    def visit_hash(klass, hash)
      klass = klass.to_s.classify.constantize unless klass.is_a?(Class)
      owner = klass.new
      after_created = []
      
      hash.each do |key, value|
        reflection = klass.__reflection__[key]
        if reflection
          case reflection.macro
          when :belongs_to
            association = value.accept_for_hickey(reflection.klass, self)
            owner.send("#{reflection.primary_key_name}=", association.id)
          when :has_one
            after_created << Proc.new do
              value[reflection.primary_key_name] = owner.id
              value.accept_for_hickey(reflection.klass, self)
            end
          when :has_many
            if through_reflection = reflection.through_reflection
              owner_associations = owner.send(key)
              after_created << Proc.new do
                target = value.accept_for_hickey(reflection.klass, self)
                target.each do |record|
                  owner_associations.proxy_target << through_reflection.klass.send(:with_scope, :create => owner_associations.send(:construct_join_attributes, record)) do
                    visit_hash(through_reflection.klass, {})
                  end
                end
              end
            else
              after_created << Proc.new do
                value.each do |obj|
                  obj[reflection.primary_key_name] = owner.id
                end
                value.accept_for_hickey(reflection.klass, self)
              end
            end
          when :has_and_belongs_to_many
            association = value.accept_for_hickey(reflection.klass, self)
            owner_associations = owner.send(key)
            after_created << Proc.new do
              association.each do |record|
                owner_associations.send(:insert_record, record)
              end
            end
          end
        else
          owner.send("#{key}=", value)
        end
      end
      owner.attach_timestamps
      owner.send(:create_without_callbacks)
      
      after_created.each do |proc|
        proc.call
      end

      owner
    end
  end
end
