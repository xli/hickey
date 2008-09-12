require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class HasOneAssociationTest < Test::Unit::TestCase
  def test_user_has_one_address
    Hickey.kiss :user => {:address => {:location => 'BeiJing'}}
    assert_equal 'BeiJing', user.address.location
  end
  
  def test_with_option_foreign_key
    Hickey.kiss :author => {:address => {:location => 'BeiJing'}}
    assert_equal 'BeiJing', author.address.location
  end
  
  def test_with_option_as_and_class_name
    Hickey.kiss :author => {:working_topic => {:title => 'Hello world'}}
    assert_equal 'Hello world', author.working_topic.title
  end
  
  def test_with_option_through_has_one
    Hickey.kiss :author => {:country => {:name => 'China'}}
    assert_equal 'China', author.country.name
  end
  
  def test_with_option_through_source
    Hickey.kiss :author => {:living_country => {:name => 'China'}}
    assert_equal 'China', author.living_country.name
  end

  def test_with_option_through_source_type
    Hickey.kiss :disscution => {:speaker => {:login => 'xli'}}
    assert_equal 'xli', disscution.speaker.login
  end
  
  def test_through_and_as
    # fail('do we need this?')
  end

  #active_record couldn't work on has_one :through belongs to
  def xtest_with_option_through_belongs_to
    user = User.create(:login => 'xli')
    DisscutionBelongsToTopic.create!(:owner => user)
    assert_equal 'xli', d.owner.login
    
    Hickey.kiss :disscution_belongs_to_topic => {:owner => {:login => 'xli'}}
    assert_equal 'xli', disscution_belongs_to_topic.owner.login
  end

  #active_record couldn't work on has_one :through belongs to
  def xtest_with_option_through_source_type
    Hickey.kiss :disscution_belongs_to_topic => {:speaker => {:login => 'xli'}}
    assert_equal 'xli', disscution_belongs_to_topic.speaker.login
  end
end
