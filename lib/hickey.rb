
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
    r = Model.kiss_domains(domains)
    r.size == 1 ? r.values.first : r
  end
  
  module_function :kiss
end
