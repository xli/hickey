
begin
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require 'active_record'
end

require 'hickey/acceptor'
require 'hickey/active_record_ext'
require 'hickey/domain_detector'

module Hickey
  def kiss(domain)
    DomainDetector.new.visit(domain)
  end
  
  module_function :kiss
end
