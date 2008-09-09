class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :country
  should_bypass_all_callbacks_and_validations
end
