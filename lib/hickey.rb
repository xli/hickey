
begin
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require 'active_record'
end

require 'hickey/active_record_ext'
require 'hickey/model'

module Hickey
  def kiss(domain)
    domain.collect do |name, attributes|
      if attributes.kind_of?(Array)
        Model.kiss_models(name, attributes)
      else
        Model.kiss(name, attributes)
      end
    end
  end
  
  module_function :kiss
end
