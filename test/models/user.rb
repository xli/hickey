class User < ActiveRecord::Base
  has_and_belongs_to_many :countries
  has_many :projects_members
  has_many :projects, :through => :projects_members
end
