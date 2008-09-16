require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class FindOrCreateActionsTest < Test::Unit::TestCase
  def test_create_action
    assert Hickey.kiss(:simple => {:create => {}})
  end
  
  def test_create_multi_models
    result = Hickey.kiss(:simple => {:create => {}}, :user => {:create => {:login => 'xli'}})
    assert_equal({:simple => Simple.find(:first), :user => User.find(:first)}, result)
  end
  
  def test_create_association_model
    Hickey.kiss(:project => {:identifier => 'hickey', :users => [{:create => {:login => 'xli', :admin => true}}]})
    
    assert_equal 'xli', project.users.first.login
  end
  
  def test_find_action
    simple1 = Hickey.kiss(:simple => {})
    simple2 = Hickey.kiss(:simple => {:find => {}})
    assert_equal simple1, simple2
    assert_equal 1, Simple.count(:all)
  end
  
  def test_find_by_attributes
    Hickey.kiss(:user => {:login => 'mm'})
    user1 = Hickey.kiss(:user => {:login => 'xli'})
    user2 = Hickey.kiss(:user => {:find => {:login => 'xli'}})
    assert_equal user1, user2
    assert_equal 2, User.count(:all)
  end
  
  def test_should_find_model_without_association
    Hickey.kiss(:project => {:identifier => 'hickey', :users => [{:login => 'xli', :admin => true}]})

    project = Hickey.kiss(:project => {:find => {:identifier => 'hickey', :users => [{:login => 'xli', :admin => true}]}})
    assert_equal 'hickey', project.identifier
    assert_equal 'xli', project.users.first.login
    assert_equal 1, Project.count(:all)
    
    assert_equal 2, User.count(:all)
  end
  
  def test_find_model_with_finding_association
    Hickey.kiss(:project => {:identifier => 'hickey', :users => [{:login => 'xli', :admin => true}]})

    project = Hickey.kiss(:project => {:find => {:identifier => 'hickey', :users => [{:find => {:login => 'xli', :admin => true}}]}})
    assert_equal 'hickey', project.identifier
    assert_equal 'xli', project.users.first.login
    assert_equal 1, Project.count(:all)
    
    assert_equal 1, User.count(:all)
  end
  
  def test_find_or_create
    Hickey.kiss(:simple => {:find_or_create => {}})
    assert_equal 1, Simple.count(:all)
    Hickey.kiss(:simple => {:find_or_create => {}})
    assert_equal 1, Simple.count(:all)
  end
end
