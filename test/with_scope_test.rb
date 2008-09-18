require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class WithScopeTest < Test::Unit::TestCase
  def test_should_auto_associate_models_even_they_are_not_related_directly
    Hickey.kiss :project => {
      :identifier => 'hickey', :cards => [
        {
          :name => 'first card', 
          :taggings => [{:tag => {:name => 'first_tag'}}],
        }
      ]
    }
    assert_equal ['first_tag'], project.tags.collect(&:name)
    assert_equal ['first card'], project.cards.collect(&:name)
  end
  
  def test_should_work_with_find_or_create_actions
    Hickey.kiss :project => {
      :identifier => 'hickey', :cards => [
        {
          :name => 'first card', 
          :taggings => [{:tag => {:find_or_create => {:name => 'first_tag'}}}],
        },
        {
          :name => 'dont make me think', 
          :taggings => [{:tag => {:find_or_create => {:name => 'first_tag'}}}],
        }
      ]
    }
    assert_equal ['first_tag'], project.tags.collect(&:name)
    assert_equal ['first card', 'dont make me think'].sort, project.cards.collect(&:name).sort
  end
  
  def test_should_not_effect_object_out_of_model_scope
    Hickey.kiss :writer => {:login => 'writer', :disscutions => [{:speaker => {:login => 'xli'}}, {:speaker => {:login => 'oo'}}]}
    assert_equal 2, writer.disscutions.collect(&:id).uniq.size
  end

  def test_should_ignore_keys_that_dont_belong_to_model_in_the_scopes
    project = Hickey.kiss :project => {
      :identifier => 'hickey', :cards => [
        {
          :name => 'first card',
          :taggings => [{:tag => {:find_or_create => {:name => 'first_tag'}}}],
        },
        {
          :name => 'second card',
          :taggings => [{:tag => {:find_or_create => {:name => 'first_tag'}}}],
        }
      ]
    }
    tag = project.cards.first.taggings.first.tag
    assert_equal 'first_tag', tag.read_attribute('name')
    assert_nil tag.read_attribute('card_id')
  end
end