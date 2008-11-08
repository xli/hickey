require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class HasAndBelongsToManyAssociationTest < Test::Unit::TestCase
  def test_create_associated_has_and_belongs_to_many_models
    Hickey.dump :user => {:login => 'xli', :countries => [{:name => 'China'}]}

    assert_equal 1, user.countries.size
    assert_equal 'China', user.countries.first.name
  end
end