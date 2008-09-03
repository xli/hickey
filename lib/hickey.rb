
begin
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require 'active_record'
end

module Hickey
  def kiss(domain)
    domain.collect do |name, attributes|
      if attributes.kind_of?(Array)
        Models.kiss(name, attributes)
      else
        Model.kiss(name, attributes)
      end
    end
  end
  
  module_function :kiss
  
  class Model
    def self.kiss(name, attributes)
      new(name, attributes).kiss
    end
    
    def initialize(name, attributes)
      @name = name
      @attributes = attributes
    end
    
    def kiss
      object = @name.to_s.classify.constantize.new(@attributes)
      object.save_with_validation(false)
      object
    end
  end
  
  class Models
    def self.kiss(name, attributes)
      attributes.collect {|kid| Model.kiss(name, kid)}
    end
  end
end
