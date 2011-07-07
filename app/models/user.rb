class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :questions_attributes

  attr_accessor :terms_of_service

  validates_presence_of :name
  validates :terms_of_service, :acceptance => true


  belongs_to :role
  belongs_to :title

  has_many :areas_users,
           :class_name => 'AreaUser'

  has_many :areas,
           :through => :areas_users

  has_many :contents_users,
           :class_name => 'ContentUser'
  has_many :contents,
           :through => :contents_users

  has_many :questions,
           :through => :contents_users
  has_many :proposals_done,
           :through => :contents_users

  has_many :proposal_data,
           :class_name => 'ProposalData'
  has_many :proposals_received,
           :through => :proposal_data,
           :source => :proposal


  has_many :answer_data,
           :class_name => 'AnswerData'

  has_many :answers,
           :through => :answer_data

  has_many :poll_answers,
           :class_name => 'AnswerUser'

  has_many :follows
  has_many :participations


  has_many :actions,
           :class_name => 'UserPublicStream',
           :order => 'updated_at desc'
  has_many :user_private_streams


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

  accepts_nested_attributes_for :questions

  def first_name
    self.name.split(' ').first if self.name.present?
  end

end
