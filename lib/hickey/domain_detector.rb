module Hickey
  module DomainDetector
    module BelongsToAssociation
      def belongs_to(owner, reflection, attr_value)
        association = attr_value.accept_for_hickey(reflection.klass, self)
        owner.send("#{reflection.primary_key_name}=", association.id)
        Proc.new{}
      end
    end
    
    module HasOneAssociation
      def has_one(owner, reflection, attr_value)
        Proc.new do
          attr_value[reflection.primary_key_name] = owner.id
          attr_value.accept_for_hickey(reflection.klass, self)
        end
      end
    end
    
    module HasManyAssociation
      def has_many(owner, reflection, attr_value)
        return has_many_through(owner, reflection, attr_value) if reflection.through_reflection

        Proc.new do
          attr_value.each do |obj|
            obj[reflection.primary_key_name] = owner.id
          end
          attr_value.accept_for_hickey(reflection.klass, self)
        end
      end
    end
    
    module HasManyThroughAssociation
      def has_many_through(owner, reflection, attr_value)
        through_reflection = reflection.through_reflection
        Proc.new do
          owner_associations = owner.send(reflection.name)
          target = attr_value.accept_for_hickey(reflection.klass, self)
          target.each do |record|
            association = owner_associations.send(:construct_join_attributes, record)
            proxy = through_reflection.klass.send(:with_scope, :create => association) do
              visit_hash(through_reflection.klass, {})
            end
            owner_associations.proxy_target << proxy
          end
        end
      end
    end
    
    module HasAndBelongsToManyAssociation
      def has_and_belongs_to_many(owner, reflection, attr_value)
        association = attr_value.accept_for_hickey(reflection.klass, self)
        Proc.new do
          association.each do |record|
            owner.send(reflection.name).send(:insert_record, record)
          end
        end
      end
    end
    
    class Base
      include BelongsToAssociation
      include HasOneAssociation
      include HasManyAssociation
      include HasManyThroughAssociation
      include HasAndBelongsToManyAssociation
      
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
          if reflection = klass.__reflection__[key]
            after_created << send(reflection.macro, owner, reflection, value)
          else
            owner.send("#{key}=", value)
          end
        end
        owner.attach_timestamps
        owner.send(:create_without_callbacks)

        after_created.each(&:call)

        owner
      end
    end
  end
end
