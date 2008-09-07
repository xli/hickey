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
      domains = Model.kiss_domains(attributes)
      @attributes = domains.reject {|name, value| value.kind_of?(Array)}
      @associations = domains.select {|name, value| value.kind_of?(Array)}
    end
    
    def kiss
      object = @name.to_s.classify.constantize.new(@attributes)
      object.attach_timestamps
      object.send(:create_without_callbacks)
      
      @associations.each do |name, value|
        object.send(name) << value
      end
      
      object
    end
  end
end
