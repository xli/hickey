require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class SingleModelTest < Test::Unit::TestCase
  def test_create_simple_model
    Hickey.kiss(:simple => {})
    assert_equal 1, Simple.find(:all).size
  end

  def test_should_return_created_domain
    result = Hickey.kiss(:simple => {})
    assert_equal Simple.find(:first), result
  end

  def test_should_return_created_domain
    result = Hickey.kiss(:simple => [{}])
    assert_equal Simple.find(:all), result
  end

  def test_should_return_created_domain_as_hash_when_kiss_multi_models
    result = Hickey.kiss(:simple => {}, :user => {:login => 'xli'})
    assert_equal({:simple => Simple.find(:first), :user => User.find(:first)}, result)
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
      def should_be_bypass
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

  def test_should_ignore_created_timestamp_attributes_when_they_have_value
    t = Time.parse("1/1/2000")
    Hickey.kiss(:project => {:identifier => 'hickey', :created_on => t, :created_at => t})

    assert_equal t, project.created_on
    assert_equal t, project.created_at
  end
  
  def test_should_update_object_specified
    project = Hickey.kiss(:project => {:identifier => 'hickey'})
    Hickey.kiss project => {:identifier => 'new project identifier'}
    project.reload
    
    assert_equal 'new project identifier', project.identifier
  end

  def test_create_object_associating_with_exist_object
    user = Hickey.kiss(:user => {:login => 'xli', :admin => true})
    Hickey.kiss(:project => {:identifier => 'hickey', :users => [user]})
    
    assert_equal 'xli', project.users.first.login
  end

  def test_should_raise_error_when_create_model_failed_by_sql_error
    assert_raise ActiveRecord::StatementInvalid do
      Hickey.kiss(:property_definition => {}) #type should not be nil
    end
  end
  
  def test_should_work_after_redefined_accessor_method_for_column
    Hickey.kiss(:prisoner => {:login => 'xli'})
    assert_equal 'xli', prisoner.login
  end
end
