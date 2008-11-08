require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class HasManyAssociationTest < Test::Unit::TestCase

  def test_create_associated_empty_models
    Hickey.dump(:project => {:identifier => 'hickey', :projects_members => []})
    assert_equal [], project.projects_members
  end
  
  def test_create_associated_many_existed_models
    Hickey.dump :project => {:identifier => 'hickey', :projects_members => [{}, {}]}
    
    assert_equal 2, project.projects_members.size
    assert_not_nil project.projects_members.first
    assert_not_nil project.projects_members.last
  end
  
  def test_option_class_name
    Hickey.dump :user => {:login => 'xli', :my_topics => [{:title => 'Bla bla...'}]}
    assert_equal 1, user.my_topics.size
    assert_equal 'Bla bla...', user.my_topics.first.title
  end

  def test_option_through_models
    Hickey.dump :project => {:identifier => 'hickey', :users => [{:login => 'xli'}]}
    assert_equal 1, project.projects_members.size
    assert_not_nil project.projects_members.first.user
    assert_equal 'xli', project.projects_members.first.user.login
    
    assert_equal 'xli', project.users.first.login
  end

  def test_option_foreign_key
    Hickey.dump :writer => {:login => 'xli', :addresses => [{:location => 'BeiJing'}, {:location => 'ShangHai'}]}
    assert_equal 2, writer.addresses.size
    assert_equal ['BeiJing', 'ShangHai'].sort, writer.addresses.collect(&:location).sort
  end

  def test_option_as
    Hickey.dump :writer => {:topics => [{:title => 'Hello world'}, {:title => 'Hello world again'}]}
    assert_equal ['Hello world', 'Hello world again'].sort, writer.topics.collect(&:title).sort
  end
  
  def test_option_through_and_as
    Hickey.dump :writer => {:login => 'writer', :disscutions => [{:speaker => {:login => 'xli'}}, {:speaker => {:login => 'oo'}}]}
    speakers = writer.disscutions.collect(&:speaker)
    assert_equal ['writer', 'xli', 'oo'].sort, User.find(:all).collect(&:login).sort
    assert_equal 2, speakers.size
    speakers = [speakers.first.login, speakers.last.login]
    assert_equal ['xli', 'oo'].sort, speakers.sort
  end

  def test_specifying_type_attribute_for_single_table_inheritance
    Hickey.dump :project => {:all_property_definitions => [{:name => 'status', :type => 'EnumPropertyDefinition'}, {:name => 'owner', :type => 'UserPropertyDefinition'}]}
    
    assert_equal ['status', 'owner'].sort, project.all_property_definitions.collect(&:name).sort
  end
  
  def test_subclass_relationship_of_single_table_inheritance
    Hickey.dump :property_definition => {:type => 'EnumPropertyDefinition', :enum_values => [{:value => 'new'}, {:value => 'open'}]}
    
    assert_equal ['new', 'open'].sort, property_definition.enum_values.collect(&:value).sort
  end
  
  def test_should_raise_active_record_subclass_not_found_error_when_cant_find_subclass
    assert_raise ActiveRecord::SubclassNotFound do
      Hickey.dump :property_definition => {:type => 'NotPropertyDefinition'}
    end
  end
  
end
