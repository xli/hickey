class Country < ActiveRecord::Base
  has_and_belongs_to_many :users
  should_bypass_all_callbacks_and_validations
end
