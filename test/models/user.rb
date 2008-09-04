class User < ActiveRecord::Base
  has_many :projects_members
  has_many :projects, :through => :projects_members
end
