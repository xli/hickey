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
        return has_one_through(owner, reflection, attr_value) if reflection.through_reflection

        Proc.new do
          attr_value[reflection.primary_key_name] = owner.id
          if reflection.options[:as]
            attr_value["#{reflection.options[:as]}_type"] = owner.class.base_class.name.to_s
          end
          attr_value.accept_for_hickey(reflection.klass, self)
        end
      end
    end
    
    module HasOneThroughAssociation
      def has_one_through(owner, reflection, attr_value)
        through_reflection = reflection.through_reflection
        Proc.new do
          target = attr_value.accept_for_hickey(reflection.klass, self)
          association = ActiveRecord::Associations::HasOneThroughAssociation.new(owner, reflection).send(:construct_join_attributes, target)
          association.accept_for_hickey(through_reflection.klass, self)
        end
      end
    end
    
    module HasManyAssociation
      def has_many(owner, reflection, attr_value)
        return has_many_through(owner, reflection, attr_value) if reflection.through_reflection

        Proc.new do
          attr_value.each do |obj|
            obj[reflection.primary_key_name] = owner.id
            if reflection.options[:as]
              obj["#{reflection.options[:as]}_type"] = owner.class.base_class.name.to_s
            end
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
      include HasOneThroughAssociation
      include HasManyAssociation
      include HasManyThroughAssociation
      include HasAndBelongsToManyAssociation
      
      cattr_accessor :configurations, :instance_writer => false
      @@configurations = {}
      
      def visit(domain)
        r = {}
        domain.each do |key, value|
          r[key] = value.accept_for_hickey(key, self)
        end
        r.size == 1 ? r.values.first : r
      end
      
      def visit_hash(attribute, record)
        owner = new_instance(attribute, record)
        after_created = []

        record.each do |key, value|
          if reflection = owner.class.reflections[key]
            after_created << send(reflection.macro, owner, reflection, value)
          else
            owner.send :write_attribute, key, value
          end
        end

        owner.instance_eval do
          def valid_without_callbacks?
            true
          end
        end
        config = @@configurations[owner.class.name.underscore.to_sym] || {}
        unless config[:callbacks] == :all
          owner.instance_eval do
            def callback(*args)
              true
            end
          end
        end
        owner.save_with_validation!

        after_created.each(&:call)
        owner
      end
      
      private
      def new_instance(class_or_instance, record)
        return class_or_instance unless ['Class', 'String', 'Symbol'].include?(class_or_instance.class.name)
        
        klass = class_or_instance.is_a?(Class) ? class_or_instance : class_or_instance.to_s.classify.constantize
        if (subclass_name = record[klass.inheritance_column.to_sym]).blank?
          klass.new
        else
          begin
            subclass_name.to_s.classify.constantize.new
          rescue NameError
            raise ActiveRecord::SubclassNotFound,
              "The single-table inheritance mechanism failed to locate the subclass: '#{subclass_name}'. " +
              "This error is raised because the column '#{klass.inheritance_column}' is reserved for storing the class in case of inheritance. " +
              "Please rename this column if you didn't intend it to be used for storing the inheritance class " +
              "or overwrite #{klass.name}.inheritance_column to use another column for that information."
          end
        end
      end

    end
  end
end
