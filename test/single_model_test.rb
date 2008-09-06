require File.expand_path(File.dirname(__FILE__)) + '/test_helper'
require 'models/simple'
require 'models/user'
require 'models/project'

class SingleModelTest < Test::Unit::TestCase
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

  def test_create_model_with_attributes
    Hickey.kiss(:user => {:login => 'xli', :admin => true})
    user = User.find_by_login_and_admin('xli', true)
    assert_not_nil user
  end
  
  def test_should_auto_set_created_at_and_updated_at_attributes
    Hickey.kiss(:project => {:identifier => 'hickey'})
    assert_not_nil Project.find(:first).created_at
    assert_not_nil Project.find(:first).updated_at
  end

  def test_should_auto_set_created_on_and_updated_on_attributes
    Hickey.kiss(:project => {:identifier => 'hickey'})
    assert_not_nil Project.find(:first).created_on
    assert_not_nil Project.find(:first).updated_on
  end
end
