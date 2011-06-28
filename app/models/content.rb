class Content < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'

  has_many :areas_contents, :class_name => "AreaContent"
  has_many :areas, :through => :areas_contents
  has_many :contents_users, :class_name => "ContentUser"
  has_many :users, :through => :contents_users
  has_many :follows
  has_many :participations
end
