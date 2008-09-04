require File.expand_path(File.dirname(__FILE__)) + '/test_helper'
require 'models/user'

class HickeyTest < Test::Unit::TestCase
  def test_create_model_with_attributes
    Hickey.kiss(:user => {:login => 'xli', :admin => true})
    user = User.find_by_login_and_admin('xli', true)
    assert_not_nil user
  end
end
