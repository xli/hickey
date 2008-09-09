require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class ModelAssociationTest < Test::Unit::TestCase
  
  def test_should_return_same_with_models_loaded_from_db_after_created_models
    project = Hickey.kiss :project => {:identifier => 'hickey', :projects_members => [:user => {:login => 'xli'}]}
    
    db_project = Project.find(:first)
    assert_equal project, db_project
    assert_equal project.projects_members.size, db_project.projects_members.size
    assert_equal project.projects_members.first.user, db_project.projects_members.first.user
  end

  def test_create_associated_both_has_many_association_and_belongs_to_association_models
    Hickey.kiss :project => {:identifier => 'hickey', :projects_members => [:user => {:login => 'xli'}]}
    assert_equal 1, project.projects_members.size
    assert_not_nil project.projects_members.first.user
    assert_equal 'xli', project.projects_members.first.user.login
  end
  
end
