class ProjectsMember < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  should_bypass_all_callbacks_and_validations
end