class User < ActiveRecord::Base
  belongs_to :role
  belongs_to :sex
  belongs_to :title

  has_many :areas_users,
           :class_name => 'AreaUser'

  has_many :areas,
           :through => :areas_users

  has_many :contents_users,
           :class_name => 'ContentUser'

  has_many :contents,
           :through => :contents_users

  has_many :follows
  has_many :participations

  has_many :poll_answers,
           :class_name => 'AnswerUser'

  has_many :user_public_streams
  has_many :user_private_streams
  has_many :answers

  ###
  ## Follows associations
  # Required to get areas_followed and users_followed by this user
  has_many :followed_items,
           :class_name => 'Follow'

  has_many :areas_following,
           :through      => :followed_items,
           :source       => :follow_item,
           :source_type  => 'Area'

  has_many :users_following,
           :through      => :followed_items,
           :source       => :follow_item,
           :source_type  => 'User'

  # Required to get followers if this user
  has_many :follows,
           :as => :follow_item
  has_many :followers,
           :through => :follows,
           :source => :user

end
