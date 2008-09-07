module Hickey
  class Model
    class <<self
      def kiss_domains(domains)
        returning({})do |r|
          domains.each do |name, attributes|
            r[name] = if attributes.kind_of?(Array)
              attributes.collect {|kid| new(name, kid).kiss}
            elsif attributes.kind_of?(Hash)
              new(name, attributes).kiss
            else
              attributes
            end
          end
        end
      end
    end
    
    def initialize(name, attributes)
      @name = name
      @attributes = attributes
    end
    
    def kiss
      @column_values = @attributes.reject {|name, value| association?(value)}
      @associations = @attributes.select {|name, value| association?(value)}

      object = @name.to_s.classify.constantize.new(@column_values)
      object.attach_timestamps
      object.send(:create_without_callbacks)
      
      @associations.each do |name, value|
        if value.kind_of?(Array)
          r = value.collect do |v|
            v.each do |attr_name, attr_value|
              v[attr_name] = Model.new(attr_name, attr_value).kiss if attr_value.kind_of?(Hash)
            end
          end
          object.send(name) << object.send(name).build(r)
        else
          object.send("#{name}=", Model.new(name, value).kiss)
        end
      end
      
      object
    end
    
    private
    def association?(value)
      value.kind_of?(Array) || value.kind_of?(Hash)
    end
  end
end
