require 'hickey/domain_detector/base'
require 'hickey/domain_detector/associations'
require 'hickey/domain_detector/configurable'

Hickey::DomainDetector::Base.class_eval do
  include Hickey::DomainDetector::BelongsToAssociation
  include Hickey::DomainDetector::HasOneAssociation
  include Hickey::DomainDetector::HasOneThroughAssociation
  include Hickey::DomainDetector::HasManyAssociation
  include Hickey::DomainDetector::HasManyThroughAssociation
  include Hickey::DomainDetector::HasAndBelongsToManyAssociation
  include Hickey::DomainDetector::Configurable
end
