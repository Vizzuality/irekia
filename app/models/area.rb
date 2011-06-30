class Area < ActiveRecord::Base
  has_many :areas_users, :class_name => 'AreaUser'
  has_many :users, :through => :areas_users
  has_many :areas_contents, :class_name => 'AreaContent'
  has_many :contents, :through => :areas_contents
  has_many :actions, :class_name => 'AreaPublicStream'

  def team
    users.order('hierarchy ASC')
  end

end
