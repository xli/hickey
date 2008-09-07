require File.expand_path(File.dirname(__FILE__)) + '/test_helper'
require 'models/projects_member'
require 'models/user'
require 'models/project'

class ModelAssociationTest < Test::Unit::TestCase
  def test_has_many_association_with_empty_models
    project = Hickey.kiss(:project => {:identifier => 'hickey', :projects_members => []})
    assert_equal [], project.projects_members
  end
  
  def test_create_associated_has_many_models
    project = Hickey.kiss :project => {:identifier => 'hickey', :projects_members => [{}, {}]}
    
    assert_equal 2, project.projects_members.size
    assert_not_nil project.projects_members.first
    assert_not_nil project.projects_members.last
  end
  
  def test_create_associated_belongs_to_model
    projects_member = Hickey.kiss :projects_member => {:user => {:login => 'xli'}}
    assert_not_nil projects_member.user
    assert_equal 'xli', projects_member.user.login
  end
  
  def test_create_associated_has_many_and_belongs_to_models
    project = Hickey.kiss :project => {:identifier => 'hickey', :projects_members => [:user => {:login => 'xli'}]}
    assert_equal 1, project.projects_members.size
    assert_not_nil project.projects_members.first.user
    assert_equal 'xli', project.projects_members.first.user.login
  end
  
  def test_create_associated_has_many_through_models
    project = Hickey.kiss :project => {:identifier => 'hickey', :users => [{:login => 'xli'}]}
    assert_equal 1, project.projects_members.size
    assert_not_nil project.projects_members.first.user
    assert_equal 'xli', project.projects_members.first.user.login

    assert_equal 'xli', project.users.first.login
  end
  
  def test_should_return_same_with_models_loaded_from_db_after_created_models
    project = Hickey.kiss :project => {:identifier => 'hickey', :projects_members => [:user => {:login => 'xli'}]}
    
    db_project = Project.find(:first)
    assert_equal project, db_project
    assert_equal project.projects_members.size, db_project.projects_members.size
    assert_equal project.projects_members.first.user, db_project.projects_members.first.user
  end
end
