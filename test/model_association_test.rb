require File.expand_path(File.dirname(__FILE__)) + '/test_helper'
require 'models/projects_member'
require 'models/user'
require 'models/project'
require 'models/country'
require 'models/topic'

class ModelAssociationTest < Test::Unit::TestCase
  
  def test_should_return_same_with_models_loaded_from_db_after_created_models
    project = Hickey.kiss :project => {:identifier => 'hickey', :projects_members => [:user => {:login => 'xli'}]}
    
    db_project = Project.find(:first)
    assert_equal project, db_project
    assert_equal project.projects_members.size, db_project.projects_members.size
    assert_equal project.projects_members.first.user, db_project.projects_members.first.user
  end

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
  
  def test_create_associated_belongs_to_model
    Hickey.kiss :projects_member => {:user => {:login => 'xli'}}
    assert_not_nil projects_member.user
    assert_equal 'xli', projects_member.user.login
  end
  
  def test_create_associated_has_many_and_belongs_to_models
    Hickey.kiss :project => {:identifier => 'hickey', :projects_members => [:user => {:login => 'xli'}]}
    assert_equal 1, project.projects_members.size
    assert_not_nil project.projects_members.first.user
    assert_equal 'xli', project.projects_members.first.user.login
  end
  
  def test_create_associated_has_many_through_models
    Hickey.kiss :project => {:identifier => 'hickey', :users => [{:login => 'xli'}]}
    assert_equal 1, project.projects_members.size
    assert_not_nil project.projects_members.first.user
    assert_equal 'xli', project.projects_members.first.user.login
    
    assert_equal 'xli', project.users.first.login
  end
  
  def test_create_associated_has_and_belongs_to_many_models
    Hickey.kiss :user => {:login => 'xli', :countries => [{:name => 'China'}]}

    assert_equal 1, user.countries.size
    assert_equal 'China', user.countries.first.name
  end
  
  def test_create_associated_has_many_models_with_class_name
    Hickey.kiss :user => {:login => 'xli', :my_topics => [{:title => 'Bla bla...'}]}
    assert_equal 1, user.my_topics.size
    assert_equal 'Bla bla...', user.my_topics.first.title
  end

  def test_create_associated_belongs_to_model_with_class_name
    Hickey.kiss :topic => {:title => 'Bla bla...', :owner => {:login => 'xli'}}
    
    topic = Topic.find(:first)
    assert_not_nil topic.owner
    assert_equal 'xli', topic.owner.login
  end
end
