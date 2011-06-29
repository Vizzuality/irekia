class User < ActiveRecord::Base
  belongs_to :role
  belongs_to :sex
  belongs_to :title

  has_many :areas_users, :class_name => 'AreaUser'
  has_many :areas, :through => :areas_users
  has_many :contents_users, :class_name => 'ContentUser'
  has_many :contents, :through => :contents_users
  has_many :follows
  has_many :participations
  has_many :poll_answers, :class_name => 'AnswerUser'
  has_many :user_public_streams
  has_many :user_private_streams
  has_many :answers
end
