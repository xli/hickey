class Topic < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => :user_id
  belongs_to :writer, :polymorphic => true
  belongs_to :disscution
  should_bypass_all_callbacks_and_validations
end

class Disscution < ActiveRecord::Base
  has_one :topic
  has_one :speaker, :through => :topic, :source => :writer, :source_type => 'Author'
  should_bypass_all_callbacks_and_validations
end

class DisscutionBelongsToTopic < ActiveRecord::Base
  belongs_to :topic
  has_one :owner, :through => :topic
  has_one :speaker, :through => :topic, :source => :writer, :source_type => 'Author'
  should_bypass_all_callbacks_and_validations
end
