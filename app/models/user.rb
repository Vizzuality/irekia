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
  attr_accessible :name,
                  :lastname,
                  :twitter_username,
                  :email,
                  :remember_me,
                  :terms_of_service,
                  :role_id,
                  :title_id,
                  :birthday,
                  :description,
                  :is_woman,
                  :province_id,
                  :city_id,
                  :postal_code,
                  :first_time,
                  :profile_pictures_attributes,
                  :questions_attributes,
                  :question_data_attributes,
                  :areas_users_attributes,
                  :follows_attributes

  attr_accessor :terms_of_service

  before_validation :check_blank_name, :on => :create

  validates :terms_of_service, :acceptance => true
  validates :name, :presence => true, :on => :update
  validates :lastname, :presence => true, :on => :update

  belongs_to :role,
             :select => 'id, name_i18n_key'
  belongs_to :title,
             :select => 'id, name_i18n_key'

  has_many :areas_users,
           :class_name => 'AreaUser'

  has_many :areas,
           :through => :areas_users

  has_many :contents_users,
           :class_name => 'ContentUser'
  has_many :contents,
           :through => :contents_users
  has_many :news,
           :through => :contents_users
  has_many :photos,
           :through => :contents_users
  has_many :videos,
           :through => :contents_users
  has_many :questions,
           :through => :contents_users,
           :include => [{:users => :profile_pictures}, :question_data, :comments ],
           :select => 'contents.id, contents.type, contents.published_at, contents.moderated'
  has_many :proposals_done,
           :through => :contents_users,
           :source => :proposal,
           :include => [{:users => :profile_pictures}, :proposal_data, { :comments => [:author, :comment_data] }],
           :select => 'contents.id, contents.type, contents.published_at, contents.moderated'
  has_many :events,
           :through => :contents_users,
           :include => :event_data,
           :order => 'event_data.event_date asc'

  has_many :question_data,
           :class_name => 'QuestionData'
  has_many :questions_received,
           :through => :question_data,
           :source => :question,
           :include => [{:users => [:role, :profile_pictures]}, :question_data, :comments]
  has_many :answer_data,
           :class_name => 'AnswerData'
  has_many :answers,
           :through => :answer_data
  has_many :poll_answers,
           :class_name => 'AnswerUser'

  has_many :participations
  has_many :comments
  has_many :votes
  has_many :arguments
  has_many :answer_requests

  has_many :actions,
           :class_name => 'UserPublicStream'
  has_many :followings_actions,
           :class_name => 'UserPrivateStream',
           :order      => 'published_at desc'

  has_many :profile_pictures,
           :class_name => 'Image',
           :select => 'id, photo_id, user_id, image'


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
           :source_type  => 'User',
           :include => [:profile_pictures, :areas]

  # Required to get followers of this user
  has_many :follows,
           :as => :follow_item
  has_many :followers,
           :through => :follows,
           :source => :user

  accepts_nested_attributes_for :profile_pictures, :questions, :question_data, :areas_users
  accepts_nested_attributes_for :follows, :allow_destroy => true


  pg_search_scope :search_by_name_description_province_and_city,
                  :against => [:name, :description, :province, :city],
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }

  def self.oldest_first
    order('created_at asc')
  end

  def self.politicians
    joins(:role).where('roles.name' => 'Politician').readonly(false)
  end

  def self.citizens
    joins(:role).where('roles.name' => 'Citizen').readonly(false)
  end

  def self.by_id(id)
    User.includes(:role, :title, :areas).find(id)
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data        = access_token['user_info']
    credentials = access_token['credentials']

    if user = (signed_in_resource || User.find_by_email(data['email']))
      user
    else
      user = User.new :name  => data['name'],
                      :email => data['email']

      user.password                    = Devise.friendly_token[0,20]
      user.facebook_oauth_token        = credentials['token']

      user
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data        = access_token['user_info']
    credentials = access_token['credentials']

    if user = (signed_in_resource || User.find_by_twitter_username(data['nickname']))
      user
    else
      user = User.new :name             => data['name'],
                      :twitter_username => data['nickname']

      user.password                   = Devise.friendly_token[0,20]
      user.twitter_oauth_token        = credentials['token']
      user.twitter_oauth_token_secret = credentials['secret']

      user
    end
  end

  def proposals_and_participation(filters = {}, page = 1, per_page = 4)
    if politician?
      @proposals = Proposal.select([:'contents.id', :type, :published_at, :comments_count]).joins(:areas_contents, :contents_users).where('contents_users.user_id = ? OR areas_contents.area_id = ?', id, areas.first.id)
    else
      @proposals = Proposal.select([:'contents.id', :type, :published_at, :comments_count]).joins(:contents_users).where('contents_users.user_id = ?', id)
    end

    @votes = Vote.select([:id, :type, :published_at, :'0 as comments_count']).where(:user_id => id)
    @arguments = Argument.select([:id, :type, :published_at, :'0 as comments_count']).where(:user_id => id)

    if filters[:from_politicians]
      @proposals = @proposals.from_politicians
      @votes     = @votes.joins(:proposal      => :users).where('role_id = ?', Role.politician.first.id)
      @arguments = @arguments.joins(:proposal  => :users).where('role_id = ?', Role.politician.first.id)
    elsif filters[:from_citizens]
      @proposals = @proposals.from_citizens
      @votes     = @votes.joins(:proposal     => :users).where('role_id = ?', Role.citizen.first.id)
      @arguments = @arguments.joins(:proposal => :users).where('role_id = ?', Role.citizen.first.id)
    end

    order = 'published_at desc'
    if filters[:more_polemic] == 'true'
      order = 'comments_count desc, published_at desc'
    end

    if page && per_page
      offset = (page - 1) * per_page
      offset = 0 if offset < 0
      pagination = "LIMIT #{per_page} OFFSET #{offset}"
    end

    @proposals_and_participation = User.connection.select_all(<<-SQL
      (#{@proposals.to_sql})
      UNION
      (#{@votes.to_sql})
      UNION
      (#{@arguments.to_sql})
      ORDER BY #{order}
      #{pagination}
    SQL
    ).map{|i| i['type'].constantize.by_id(i['id'])}

    @proposals_and_participation
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

  def sex
    is_woman?? 'woman' : 'man'
  end

  def active?
    !inactive?
  end

  def politician?
    role.politician? if role.present?
  end
  alias :is_politician :politician?

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

  def agenda_between(start_date, end_date)
    events.moderated.where('event_data.event_date >= ? AND event_data.event_date <= ?', start_date, end_date)
  end

  def has_requested_answer(question_id)
    answer_request(question_id).count >= 1
  end

  def has_not_requested_answer(question_id)
    answer_request(question_id).count == 0
  end

  def answer_request(question_id)
    AnswerRequest.joins(:content, :user).where('contents.id = ? AND users.id = ?', question_id, self.id)
  end

  def has_not_given_his_opinion(content)
    case content
    when Answer
      AnswerOpinion.joins(:content, :user).where('contents.id = ? AND users.id = ?', content.id, id).count == 0
    when Proposal
      content.arguments.where('user_id = ?', id).count == 0
    end
  end

  def has_given_his_opinion?(content)
    his_opinion(content).count > 0
  end

  def his_opinion(content)

    case content
    when Answer
      AnswerOpinion.joins(:content, :user).where('contents.id = ? AND users.id = ?', content.id, id)
    when Proposal
      content.votes.where('user_id = ?', id)
    end

  end

  def update_with_password(params={})
    params.delete(:current_password)
    self.update_without_password(params)
  end

  def connected_with_facebook?
    facebook_oauth_token.present?# && facebook_oauth_token_secret.present?
  end

  def connected_with_twitter?
    twitter_oauth_token.present? && twitter_oauth_token_secret.present?
  end

  def followed_item(item)
    followed_items.where(:follow_item_type => item.class.name, :follow_item_id => item.id).first
  end

  def not_following(item)
    followed_item(item).nil? if item.present?
  end

  def follow_for(item)
    followed_item(item) || Follow.new(:follow_item => item)
  end

  def follow_suggestions
    User.includes(:role, :profile_pictures, :title, :areas).politicians.where('users.id <> ?', id)
  end

  def new_followers(last_seen_at)
    followers.where('follows.created_at > ?', last_seen_at || last_sign_in_at)
  end

  def notifications_count
    count = if politician?
      (questions_count + proposals_count + comments_count + tagged_count) rescue 0
    else
      (answers_count + comments_count) rescue 0
    end
    count = 99 if count > 99
    count
  end

  def reset_counter(counter)
    update_attribute("#{counter}_count", 0) if counter
  end

  def follow_for_user(user)
    if not_following(user)
      follow          = user.follows.build
      follow.user     = self
      follow
    else
      followed_item(user)
    end
  end

  def check_blank_name
    name = email if name.blank?
  end
  private :check_blank_name

end
