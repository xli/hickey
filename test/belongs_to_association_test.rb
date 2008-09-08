require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class BelongsToAssociationTest < Test::Unit::TestCase
  def test_create_associated_belongs_to_model
    Hickey.kiss :projects_member => {:user => {:login => 'xli'}}
    assert_not_nil projects_member.user
    assert_equal 'xli', projects_member.user.login
  end
  
  def test_create_associated_belongs_to_model_with_class_name
    Hickey.kiss :topic => {:title => 'Bla bla...', :owner => {:login => 'xli'}}
    
    topic = Topic.find(:first)
    assert_not_nil topic.owner
    assert_equal 'xli', topic.owner.login
  end
end
