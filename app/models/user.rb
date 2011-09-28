class User < ActiveRecord::Base
  include PgSearch

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
  attr_accessible :name, :lastname, :email, :remember_me, :role_id, :title_id, :birthday, :description, :is_woman, :province_id, :city_id, :postal_code, :profile_pictures_attributes, :questions_attributes, :areas_users_attributes, :follows_attributes

  attr_accessor :terms_of_service

  before_validation :check_blank_name, :on => :create

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

  has_many :participations
  has_many :comments
  has_many :answer_requests

  has_many :actions,
           :class_name => 'UserPublicStream',
           :order => 'published_at desc'
  has_many :followings_actions,
           :class_name => 'UserPrivateStream',
           :order      => 'published_at desc'

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
  accepts_nested_attributes_for :follows, :allow_destroy => true

  scope :oldest_first, order('created_at asc')
  scope :politicians, joins(:role).where('roles.name = ?', 'Politician')
  scope :citizens, joins(:role).where('roles.name = ?', 'Citizen')

  pg_search_scope :search_by_name_description_province_and_city, :against => [:name, :description, :province, :city]

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)

    data        = access_token['user_info']
    credentials = access_token['credentials']

    if user = User.find_by_email(data['email'])

      user.facebook_oauth_token        = credentials['token']
      user.facebook_oauth_token_secret = credentials['secret']
      user.save!

      user
    else
      user = User.new :name  => data['name'],
                      :email => data['email']

      user.password                    = Devise.friendly_token[0,20]
      user.facebook_oauth_token        = credentials['token']
      user.facebook_oauth_token_secret = credentials['secret']

      user
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)

    data        = access_token['user_info']
    credentials = access_token['credentials']

    if user = User.find_by_email(data['email'])

      user.twitter_oauth_token        = credentials['token']
      user.twitter_oauth_token_secret = credentials['secret']
      user.save!

      user
    else
      user = User.new :name  => data['name'],
                      :email => data['email']

      user.password                   = Devise.friendly_token[0,20]
      user.twitter_oauth_token        = credentials['token']
      user.twitter_oauth_token_secret = credentials['secret']

      user
    end
  end

  def fullname
    "#{name} #{lastname}".strip
  end

  def profile_image
    @profile_image ||= self.profile_pictures.first.image.thumb.url if self.profile_pictures.present?
  end

  def profile_image_big
    @profile_image ||= self.profile_pictures.first.image.url if self.profile_pictures.present?
  end

  def active?
    !inactive?
  end

  def politician?
    role.politician? if role.present?
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

  def update_with_password(params={})
    params.delete(:current_password)
    self.update_without_password(params)
  end

  def connected_with_facebook?
    facebook_oauth_token.present? && facebook_oauth_token_secret.present?
  end

  def connected_with_twitter?
    twitter_oauth_token.present? && twitter_oauth_token_secret.present?
  end

  def not_following(item)
    followed_items.where(:follow_item_type => item.class.name, :follow_item_id => item.id).count == 0 if item.present?
  end

  def check_blank_name
    name = email if name.blank?
  end
  private :check_blank_name

end
