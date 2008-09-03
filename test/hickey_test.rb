require File.expand_path(File.dirname(__FILE__)) + '/test_helper'
require 'models/simple'

class HickeyTest < Test::Unit::TestCase
  def test_create_simple_model
    Hickey.kiss(:simple => {})
    assert_equal 1, Simple.find(:all).size
  end
  
  def test_should_return_created_domain
    result = Hickey.kiss(:simple => {})
    assert_equal Simple.find(:all), result
  end
  
  def test_should_bypass_validation_as_default
    Simple.class_eval do
      def validate
        raise 'should bypass validation'
      end
    end
    
    Hickey.kiss(:simple => {})
  ensure
    Simple.class_eval do
      def validate
      end
    end
  end
  
  def test_create_simple_model_list
    Hickey.kiss(:simple => [{}])
    assert_equal 1, Simple.find(:all).size
  end
end
