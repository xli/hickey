class Author < ActiveRecord::Base
  set_table_name "users"
  
  has_one :address, :foreign_key => 'user_id'
  has_one :working_topic, :as => :writer, :class_name => 'Topic'
  has_one :country, :through => :address
  has_one :living_country, :through => :address, :source => :country

  should_bypass_all_callbacks_and_validations
end