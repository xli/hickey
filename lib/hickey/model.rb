module Hickey
  class Model
    def self.kiss(name, attributes)
      new(name, attributes).kiss
    end
    
    def self.kiss_models(name, attributes)
      attributes.collect {|kid| Model.kiss(name, kid)}
    end
    
    def initialize(name, attributes)
      @name = name
      @attributes = attributes
    end
    
    def kiss
      object = @name.to_s.classify.constantize.new(@attributes)
      object.attach_timestamps
      object.send(:create_without_callbacks)
      object
    end
  end
end
