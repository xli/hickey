require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class HasManyAssociationTest < Test::Unit::TestCase

  def test_has_many_association_with_empty_models
    Hickey.kiss(:project => {:identifier => 'hickey', :projects_members => []})
    assert_equal [], project.projects_members
  end
  
  def test_create_associated_has_many_models
    Hickey.kiss :project => {:identifier => 'hickey', :projects_members => [{}, {}]}
    
    assert_equal 2, project.projects_members.size
    assert_not_nil project.projects_members.first
    assert_not_nil project.projects_members.last
  end
  
  def test_create_associated_has_many_models_with_class_name
    Hickey.kiss :user => {:login => 'xli', :my_topics => [{:title => 'Bla bla...'}]}
    assert_equal 1, user.my_topics.size
    assert_equal 'Bla bla...', user.my_topics.first.title
  end

  def test_create_associated_has_many_through_models
    Hickey.kiss :project => {:identifier => 'hickey', :users => [{:login => 'xli'}]}
    assert_equal 1, project.projects_members.size
    assert_not_nil project.projects_members.first.user
    assert_equal 'xli', project.projects_members.first.user.login
    
    assert_equal 'xli', project.users.first.login
  end
end