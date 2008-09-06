
begin
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require 'active_record'
end

require 'hickey/active_record_ext'
require 'hickey/model'

module Hickey
  def kiss(domains)
    r = {}
    domains.each do |name, attributes|
      r[name] = if attributes.kind_of?(Array)
        Model.kiss_models(name, attributes)
      else
        Model.kiss(name, attributes)
      end
    end
    r.size == 1 ? r.values.first : r
  end
  
  module_function :kiss
end
