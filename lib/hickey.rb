
begin
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require 'active_record'
end

require 'hickey/acceptor'
require 'hickey/domain_detector'

module Hickey
  def dump(domain)
    DomainDetector::Base.new.visit(domain)
  end
  
  def setup(domain={})
    DomainDetector::Base.configurations.merge! domain
  end
  
  module_function :dump, :setup
end
