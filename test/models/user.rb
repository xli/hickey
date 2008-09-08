class User < ActiveRecord::Base
  has_and_belongs_to_many :countries
  has_many :my_topics, :class_name => 'Topic'
  has_many :projects_members
  has_many :projects, :through => :projects_members
  should_bypass_all_callbacks_and_validations
end
