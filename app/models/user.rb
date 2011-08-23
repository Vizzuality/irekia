class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable

  attr_reader :random_password

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :random_password, :role_id, :title_id, :profile_pictures_attributes, :questions_attributes, :areas_users_attributes

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
  has_many :events,
           :through => :contents_users,
           :include => :event_data


  has_many :proposal_data,
           :class_name => 'ProposalData'
  has_many :proposals_received,
           :through => :proposal_data,
           :source => :proposal
  has_many :question_data,
           :class_name => 'QuestionData'
  has_many :questions_received,
           :through => :question_data,
           :source => :question
  has_many :answer_data,
           :class_name => 'AnswerData'
  has_many :answers,
           :through => :answer_data
  has_many :poll_answers,
           :class_name => 'AnswerUser'

  has_many :follows
  has_many :participations
  has_many :comments
  has_many :answer_requests

  has_many :actions,
           :class_name => 'UserPublicStream',
           :order => 'published_at desc'
  has_many :user_private_streams

  has_many :profile_pictures,
           :class_name => 'Image'


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

  accepts_nested_attributes_for :profile_pictures, :questions, :areas_users

  scope :oldest_first, order('created_at asc')

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['user_info']
    if user = User.find_by_email(data['email'])
      user
    else
      User.create :name     => data['name'],
                  :email    => data['email'],
                  :password => Devise.friendly_token[0,20]
    end
  end

  def first_name
    self.name.split(' ').first if self.name.present?
  end

  def profile_image_url
    @profile_image_url ||= self.profile_pictures.first.image.url if self.profile_pictures.present?
  end

  def profile_image_thumb_url
    @profile_image_thumb_url ||= self.profile_pictures.first.image.thumb.url if self.profile_pictures.present?
  end

  def active?
    !inactive?
  end

  def politic?
    role.politic? if role.present?
  end

  def administrator?
    role.administrator? if role.present?
  end

  def citizen?
    role.citizen? if role.present?
  end

  def random_password=(random_password)
    return unless random_password == 'yes'

    generated_password = User.send(:generate_token, 'encrypted_password')
    # change randomly password length in range 8..13 characters
    generated_password.slice!(13 - rand(5)..generated_password.length)
    self.password = generated_password
    self.password_confirmation = generated_password
  end

  def has_not_requested_answer(question)
    AnswerRequest.joins(:content, :user).where('contents.id = ? AND users.id = ?', question.id, self.id).count == 0
  end

  def has_not_give_his_opinion(content)
    case content
    when Answer
      AnswerOpinion.joins(:content, :user).where('contents.id = ? AND users.id = ?', content.id, id).count == 0
    when Proposal
      content.arguments.where('user_id = ?', id).count == 0
    end
  end

  def has_give_his_opinion(content)
    case content
    when Answer
      AnswerOpinion.joins(:content, :user).where('contents.id = ? AND users.id = ?', content.id, id).count > 0
    when Proposal
      content.arguments.where('user_id = ?', id).count > 0
    end

  end

end
