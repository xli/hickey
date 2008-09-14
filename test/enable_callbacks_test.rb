require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class EnableCallbacksTest < Test::Unit::TestCase
  
  def teardown
    Hickey.lipstick.clear
    Simple.public_instance_methods(false).each do |method|
      return if method == 'id'
      Simple.class_eval "def #{method};end"
    end
  end
  
  def test_invoke_all_callbacks_after_configured
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
  
  def test_invoke_callback_specified_after_configured
    #do we need this?
  end
end