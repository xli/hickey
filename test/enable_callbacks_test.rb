require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class EnableCallbacksTest < Test::Unit::TestCase
  
  def teardown
    Hickey.setup.clear
    Simple.public_instance_methods(false).each do |method|
      next if method == 'id'
      Simple.class_eval "def #{method};end"
    end
  end
  
  def test_invoke_before_save_and_after_save_after_configured_all_callbacks
    Hickey.setup(:simple => {:callbacks => :all})
    Simple.class_eval do
      before_save :create_user_before_save
      after_save :create_user_after_save
      def create_user_after_save
        Hickey.dump(:user => {:login => 'create_user_after_save'})
      end
      def create_user_before_save
        Hickey.dump(:user => {:login => 'create_user_before_save'})
      end
      def validate
        raise 'should bypass'
      end
    end
    
    Hickey.dump(:simple => {})

    assert_equal ['create_user_before_save', 'create_user_after_save'].sort, User.find(:all).collect(&:login).sort
  end

  def test_invoke_before_validation_on_create_after_configured_all_callbacks
    Hickey.setup(:simple => {:callbacks => :all})
    Simple.class_eval do
      before_validation_on_create :create_user_before_validation_on_create
      def create_user_before_validation_on_create
        Hickey.dump(:user => {:login => 'create_user_before_validation_on_create'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.dump(:simple => {})
    assert_equal ['create_user_before_validation_on_create'], User.find(:all).collect(&:login)
  end
  
  def test_invoke_before_validation_after_configured_all_callbacks
    Hickey.setup(:simple => {:callbacks => :all})
    Simple.class_eval do
      before_validation :create_user_before_validation
      def create_user_before_validation
        Hickey.dump(:user => {:login => 'create_user_before_validation'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.dump(:simple => {})
    assert_equal ['create_user_before_validation'], User.find(:all).collect(&:login)
  end
  
  def test_invoke_before_validation_after_configured_all_callbacks
    Hickey.setup(:simple => {:callbacks => :all})
    Simple.class_eval do
      after_validation :create_user_after_validation
      def create_user_after_validation
        Hickey.dump(:user => {:login => 'create_user_after_validation'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.dump(:simple => {})
    assert_equal ['create_user_after_validation'], User.find(:all).collect(&:login)
  end
  
  def test_should_not_callback_before_validation_on_create_if_pass_in_existed_model
    simple = Hickey.dump(:simple => {})
    Hickey.setup(:simple => {:callbacks => :all})
    Simple.class_eval do
      before_validation_on_create :create_user_before_validation_on_create
      def create_user_before_validation_on_create
        Hickey.dump(:user => {:login => 'create_user_before_validation_on_create'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.dump(simple => {})
    assert_equal [], User.find(:all).collect(&:login)
  end
  
  def test_should_enable_configuration_of_invoking_all_callbacks_for_all_subclasses
    Hickey.setup(:property_definition => {:callbacks => :all})
    DatePropertyDefinition.class_eval do
      after_validation :create_user_after_validation
      def create_user_after_validation
        Hickey.dump(:user => {:login => 'create_user_after_validation'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.dump(:property_definition => {:type => 'DatePropertyDefinition'})
    
    assert_equal ['create_user_after_validation'], User.find(:all).collect(&:login)
  end

  def test_invoke_callback_specified_after_configured
    Hickey.setup(:simple => {:callbacks => [:after_create, :before_create]})
    Simple.class_eval do
      before_create :create_user_before_create
      after_create :create_user_after_create
      def create_user_before_create
        Hickey.dump(:user => {:login => 'create_user_before_create'})
      end
      def create_user_after_create
        Hickey.dump(:user => {:login => 'create_user_after_create'})
      end
      def validate
        raise 'should bypass'
      end
    end

    Hickey.dump(:simple => {})
    assert_equal ['create_user_after_create', 'create_user_before_create'].sort, User.find(:all).collect(&:login).sort
  end
end
