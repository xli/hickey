require File.expand_path(File.dirname(__FILE__)) + '/test_helper'
require 'models/simple'

class SimpleModelTest < Test::Unit::TestCase
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
    Hickey.kiss(:simple => [{}, {}])
    assert_equal 2, Simple.find(:all).size
  end

  def test_should_bypass_callbacks
    Simple.class_eval do
      before_save :should_be_bypass
      def should_be_bypass
        raise 'should be bypass'
      end
    end

    Hickey.kiss(:simple => {})
  ensure
    Simple.class_eval do
      def before_save_callback
      end
    end
  end
end
