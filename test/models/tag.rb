class Tag < ActiveRecord::Base
  has_many :taggings, :class_name => '::Tagging'
  belongs_to :project
  
  should_bypass_all_callbacks_and_validations
end

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  should_bypass_all_callbacks_and_validations
end

class Card < ActiveRecord::Base
  has_many :taggings, :as => :taggable
  belongs_to :project
end
