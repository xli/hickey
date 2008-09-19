require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class EnableCallbacksTest < Test::Unit::TestCase
  
  def teardown
    Hickey.lipstick.clear
    Simple.public_instance_methods(false).each do |method|
      next if method == 'id'
      Simple.class_eval "def #{method};end"
    end
  end
  
  def test_invoke_before_save_and_after_save_after_configured_all_callbacks
    Hickey.lipstick(:simple => {:callbacks => :all})
    Simple.class_eval do
      before_save :create_user_before_save
      after_save :create_user_after_save
      def create_user_after_save
        Hickey.kiss(:user => {:login => 'create_user_after_save'})
      end
      def create_user_before_save
        Hickey.kiss(:user => {:login => 'create_user_before_save'})
      end
      def validate
        raise 'should bypass'
      end
    end
    
    Hickey.kiss(:simple => {})

    assert_equal ['create_user_before_save', 'create_user_after_save'].sort, User.find(:all).collect(&:login).sort
  end

  def test_invoke_before_validation_on_create_after_configured_all_callbacks
    Hickey.lipstick(:simple => {:callbacks => :all})
    Simple.class_eval do
      before_validation_on_create :create_user_before_validation_on_create
      def create_user_before_validation_on_create
        Hickey.kiss(:user => {:login => 'create_user_before_validation_on_create'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.kiss(:simple => {})
    assert_equal ['create_user_before_validation_on_create'], User.find(:all).collect(&:login)
  end
  
  def test_invoke_before_validation_after_configured_all_callbacks
    Hickey.lipstick(:simple => {:callbacks => :all})
    Simple.class_eval do
      before_validation :create_user_before_validation
      def create_user_before_validation
        Hickey.kiss(:user => {:login => 'create_user_before_validation'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.kiss(:simple => {})
    assert_equal ['create_user_before_validation'], User.find(:all).collect(&:login)
  end
  
  def test_invoke_before_validation_after_configured_all_callbacks
    Hickey.lipstick(:simple => {:callbacks => :all})
    Simple.class_eval do
      after_validation :create_user_after_validation
      def create_user_after_validation
        Hickey.kiss(:user => {:login => 'create_user_after_validation'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.kiss(:simple => {})
    assert_equal ['create_user_after_validation'], User.find(:all).collect(&:login)
  end
  
  def test_should_not_callback_before_validation_on_create_if_pass_in_existed_model
    simple = Hickey.kiss(:simple => {})
    Hickey.lipstick(:simple => {:callbacks => :all})
    Simple.class_eval do
      before_validation_on_create :create_user_before_validation_on_create
      def create_user_before_validation_on_create
        Hickey.kiss(:user => {:login => 'create_user_before_validation_on_create'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.kiss(simple => {})
    assert_equal [], User.find(:all).collect(&:login)
  end
  
  def test_should_enable_configuration_of_invoking_all_callbacks_for_all_subclasses
    Hickey.lipstick(:property_definition => {:callbacks => :all})
    DatePropertyDefinition.class_eval do
      after_validation :create_user_after_validation
      def create_user_after_validation
        Hickey.kiss(:user => {:login => 'create_user_after_validation'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.kiss(:property_definition => {:type => 'DatePropertyDefinition'})
    
    assert_equal ['create_user_after_validation'], User.find(:all).collect(&:login)
  end

  def test_invoke_callback_specified_after_configured
    Hickey.lipstick(:simple => {:callbacks => [:after_create]})
    Simple.class_eval do
      after_create :create_user_after_create
      def create_user_after_create
        Hickey.kiss(:user => {:login => 'create_user_after_create'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.kiss(:simple => {})
    assert_equal ['create_user_after_create'], User.find(:all).collect(&:login)
  end
end
