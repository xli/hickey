class Writer < ActiveRecord::Base
  set_table_name "users"
  
  has_many :addresses, :foreign_key => 'user_id'

  should_bypass_all_callbacks_and_validations
end