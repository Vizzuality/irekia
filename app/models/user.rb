class User < ActiveRecord::Base
  belongs_to :role

  has_many :contents_users, :class_name => 'ContentUser'
  has_many :contents, :through => :contents_users
  has_many :follows
  has_many :participations
  has_many :poll_answers, :class_name => 'AnswerUser'
end
