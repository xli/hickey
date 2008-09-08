class Topic < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => :user_id
  should_bypass_all_callbacks_and_validations
end
