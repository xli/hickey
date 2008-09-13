require 'test/unit'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'hickey'
TEST_ROOT       = File.expand_path(File.dirname(__FILE__))
ASSETS_ROOT     = TEST_ROOT + "/empty"
FIXTURES_ROOT   = TEST_ROOT + "/empty"
MIGRATIONS_ROOT = TEST_ROOT + "/empty"
SCHEMA_ROOT     = TEST_ROOT + "/empty"

require 'active_record'
require 'active_record/fixtures'
require 'active_record/test_case'
require 'database_config'
require 'growling_test'

module Hickey
  module ShouldBypassCallbacksAndValidations
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def should_bypass_all_callbacks_and_validations
        before_save :should_be_bypass
        after_save :should_be_bypass
      end
    end
    
    def validate
      should_be_bypass
    end

    def should_be_bypass
      return if $testing_active_record
      raise 'should be bypass'
    end
  end
end

ActiveRecord::Base.send(:include, Hickey::ShouldBypassCallbacksAndValidations)

require 'models/projects_member'
require 'models/user'
require 'models/project'
require 'models/country'
require 'models/topic'
require 'models/simple'
require 'models/address'
require 'models/author'
require 'models/writer'
require 'models/property_definition'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  
  def method_missing(method, *args)
    if models.include?(method.to_s)
      method.to_s.classify.constantize.find(:first)
    else
      super
    end
  end
  
  def with_testing_active_record
    $testing_active_record = true
    yield
  ensure
    $testing_active_record = false
  end
  
  def models
    return @models if defined?(@models)
    @models = []
    ObjectSpace.each_object(Class) do |klass|
      if(ActiveRecord::Base > klass)
        @models << klass.name.underscore
      end
    end
    @models
  end
end
