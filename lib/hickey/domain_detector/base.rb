module Hickey
  module DomainDetector
    class Base
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
        
        #bypass new alias method chain of save! method
        owner.save_with_validation!

        after_created.each(&:call)
        owner
      end
      
      private
      def new_instance(class_or_instance, record)
        return class_or_instance unless ['Class', 'String', 'Symbol'].include?(class_or_instance.class.name)
        compute_type(class_or_instance, record).new
      end
      
      def compute_type(class_name, record)
        klass = class_name.is_a?(Class) ? class_name : class_name.to_s.classify.constantize
        if (subclass_name = record[klass.inheritance_column.to_sym]).blank?
          klass
        else
          begin
            subclass_name.to_s.classify.constantize
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
