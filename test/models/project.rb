class Project < ActiveRecord::Base
  has_many :projects_members
  has_many :users, :through => :projects_members
  has_many :admins, :through => :projects_members, :source => :user, :conditions => ["projects_members.admin = ?", true]
  should_bypass_all_callbacks_and_validations
end
