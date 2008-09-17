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
  
  def test_should_not_effect_object_out_of_model_scope
    Hickey.kiss :writer => {:login => 'writer', :disscutions => [{:speaker => {:login => 'xli'}}, {:speaker => {:login => 'oo'}}]}
    assert_equal 2, writer.disscutions.collect(&:id).uniq.size
  end
end