class User < ActiveRecord::Base
  include PgSearch
  extend FriendlyId

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable

  friendly_id :fullname, :use => :slugged

  attr_reader :random_password

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name,
                  :lastname,
                  :twitter_username,
                  :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :terms_of_service,
                  :role_id,
                  :title_id,
                  :birthday,
                  :description,
                  :description_1,
                  :description_2,
                  :is_woman,
                  :province,
                  :city_id,
                  :postal_code,
                  :notifications_level,
                  :first_time,
                  :new_news_count,
                  :new_events_count,
                  :new_proposals_count,
                  :new_answers_count,
                  :new_comments_count,
                  :new_votes_count,
                  :new_arguments_count,
                  :new_questions_count,
                  :new_answer_requests_count,
                  :new_contents_users_count,
                  :new_follows_count,
                  :profile_picture_attributes,
                  :questions_attributes,
                  :question_data_attributes,
                  :areas_users_attributes,
                  :follows_attributes,
                  :notifications_attributes

  attr_accessor :terms_of_service, :skip_mailing

  before_validation :check_blank_name, :on => :create
  before_create :check_user_role
  after_create :default_follow
  before_destroy :reassign_contents

  validates           :terms_of_service,  :acceptance => true
  validates           :name,              :presence   => true
  validate            :lastname_if_new_user
  validates_format_of :email,             :with       => email_regexp

  belongs_to :role,
             :select => 'id, name, name_i18n_key'
  belongs_to :title,
             :select => 'id, translated_name'

  has_many :notifications,
           :include => [:item, :parent],
           :order => 'updated_at desc',
           :dependent => :destroy

  has_many :areas_users,
           :class_name => 'AreaUser',
           :dependent => :destroy

  has_many :areas,
           :through => :areas_users

  has_many :contents_users,
           :class_name => 'ContentUser'
  has_many :contents_being_tagged,
           :through => :contents_users
  has_many :news_being_tagged,
           :through => :contents_users,
           :source => :news

  has_many :contents,
           :foreign_key => :user_id
  has_many :news,
           :foreign_key => :user_id
  has_many :photos,
           :foreign_key => :user_id
  has_many :videos,
           :foreign_key => :user_id
  has_many :questions,
           :foreign_key => :user_id,
           :include => [{:author => :profile_picture}, :question_data, :comments ],
           :select => 'contents.id, contents.type, contents.published_at, contents.moderated'
  has_many :answers,
           :foreign_key => :user_id,
           :include => [{:author => :profile_picture}, :comments ],
           :select => 'contents.id, contents.type, contents.published_at, contents.moderated'
  has_many :proposals,
           :foreign_key => :user_id,
           :source => :proposal,
           :include => [{:author => :profile_picture}, :proposal_data, { :comments => [:author, :comment_data] }],
           :select => 'contents.id, contents.type, contents.published_at, contents.moderated'
  has_many :events,
           :foreign_key => :user_id,
           :include => :event_data,
           :order => 'event_data.event_date asc'
  has_many :tweets,
           :foreign_key => :user_id,
           :include => :tweet_data
  has_many :status_messages,
           :foreign_key => :user_id,
           :include => :status_message_data

  has_many :question_data,
           :class_name => 'QuestionData'
  has_many :questions_received,
           :through => :question_data,
           :source => :question,
           :include => [{:author => [:role, :profile_picture]}, :question_data, :comments]

  has_many :participations
  has_many :comments
  has_many :votes
  has_many :arguments
  has_many :answer_requests

  has_many :actions,
           :class_name => 'UserPublicStream'
  has_many :private_actions,
           :class_name => 'UserPrivateStream'

  has_one  :profile_picture,
           :class_name => 'Image',
           :select => 'id, photo_id, user_id, image',
           :dependent => :destroy


  ###
  ## Follows associations
  # Required to get areas_followed and users_followed by this user
  has_many :followed_items,
           :class_name => 'Follow',
           :dependent => :destroy

  has_many :areas_following,
           :through      => :followed_items,
           :source       => :follow_item,
           :source_type  => 'Area'

  has_many :users_following,
           :through      => :followed_items,
           :source       => :follow_item,
           :source_type  => 'User',
           :include => [:profile_picture, :areas]

  # Required to get followers of this user
  has_many :follows,
           :as => :follow_item,
           :dependent => :destroy
  has_many :followers,
           :through => :follows,
           :source => :user

  accepts_nested_attributes_for :profile_picture, :questions, :question_data, :areas_users
  accepts_nested_attributes_for :follows, :allow_destroy => true


  pg_search_scope :search_by_name,
                  :against => [:name, :lastname],
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }
  pg_search_scope :search_by_name_description_province_and_city,
                  :against => [:name, :lastname, :description, :province, :city],
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
      user.facebook_oauth_token         = credentials['token']
      user.facebook_username            = data['nickname']
      user.facebook_url                 = data['urls']['Facebook'] if data['urls'].present?
      user.save!

      user
    else
      user = User.new :name  => data['name'],
                      :email => data['email']

      user.password                    = Devise.friendly_token[0,20]
      user.facebook_oauth_token        = credentials['token']
      user.facebook_username           = data['nickname']
      user.facebook_url                = data['urls']['Facebook'] if data['urls'].present?

      user.set_profile_picture data['image'] if data['image'].present?

      user
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data        = access_token['user_info']
    credentials = access_token['credentials']

    if user = User.where(:twitter_oauth_token => credentials['token'], :twitter_oauth_token_secret => credentials['secret']).first
      user
    elsif user = (signed_in_resource || User.find_by_twitter_username(data['nickname']))
      user.twitter_oauth_token        = credentials['token']
      user.twitter_oauth_token_secret = credentials['secret']
      user.twitter_username           = data['nickname']
      user.save!
      user
    else
      user = User.new :name             => data['name'],
                      :email            => data['nickname'],
                      :twitter_username => data['nickname']

      user.password                   = Devise.friendly_token[0,20]
      user.twitter_oauth_token        = credentials['token']
      user.twitter_oauth_token_secret = credentials['secret']

      user.set_profile_picture data['image'] if data['image'].present?

      user
    end
  end

  def set_profile_picture(url)
    image = profile_picture || build_profile_picture
    image.remote_image_url = url
    image.save
  end

  def self.patxi_lopez
    find_by_external_id('8080')
  end

  def self.advisers
    User.where(:external_id => [6928, 953, 3955, 7552, 7335, 6934, 7419, 6936, 169, 7299])
  end

  def self.patxi_and_advisers
    where(:id => [User.patxi_lopez.id, User.advisers.map(&:id)].flatten)
  end

  def self.wadus
    where(:name => 'usuario dado', :lastname => 'de baja').first
  end

  def description_1
    send("description_1_#{I18n.locale.to_s}") || send("description_1_#{I18n.default_locale.to_s}")
  end

  def description_2
    send("description_2_#{I18n.locale.to_s}") || send("description_2_#{I18n.default_locale.to_s}")
  end

  def update_with_email_and_password(attributes = {})
    from_twitter = email == twitter_username
    if attributes.slice(:email, :password).present? && !from_twitter
      attributes[:password_confirmation] = attributes[:password] if attributes[:password].present?
      self.update_with_password(attributes)
    else
      attributes[:password], attributes[:current_password] = ''
      self.update_without_password(attributes)
    end
  end

  def reassign_contents
    return if self === User.wadus

    (contents_users || []).each do |content_user|
      content_user.update_attributes(:user_id => User.wadus.id)
    end

    (contents || []).each do |content|
      content.update_attributes(:user_id => User.wadus.id)
    end

    (question_data || []).each do |question_data|
      question_data.update_attributes(:user_id => User.wadus.id)
    end

    (participations || []).each do |participation|
      participation.update_attributes(:user_id => User.wadus.id)
    end

    (actions || []).each do |action|
      action.update_attributes(:user_id => User.wadus.id)
    end

    (private_actions || []).each do |private_action|
      private_action.update_attributes(:user_id => User.wadus.id)
    end
  end

  def create_public_action(item)
    public_action              = actions.find_or_create_by_event_id_and_event_type item.event_id, item.event_type
    public_action.published_at = item.published_at
    public_action.message      = item.message
    public_action.author_id    = item.author_id
    public_action.moderated    = item.moderated
    public_action.save!
  end

  def create_private_action(item)
    return if item && item.is_content?       && item.author.id == id
    return if item && item.is_participation? && (item.author.id == id || item.content.author.id == item.author.id)

    private_action = private_actions.find_or_create_by_event_id_and_event_type item.event_id, item.event_type
    private_action.published_at = item.published_at
    private_action.message      = item.message
    private_action.author_id    = item.author_id if item.author_id.present?
    private_action.moderated    = item.moderated
    private_action.save!
  end

  def change_password(current_password, new_password)
    valid_user = false
    if valid_password?(current_password)
      self.password              = new_password
      self.password_confirmation = new_password

      valid_user = save
    else
      errors.add(:password)
    end
    valid_user
  end

  def get_actions(filters, current_user)
    actions = if current_user.present?
      self.actions.moderated_or_author_is(current_user)
    else
      self.actions.moderated
    end
    actions = actions.where(:event_type => [filters[:type]].flatten.map(&:camelize)) if filters[:type].present?

    actions = if filters[:more_polemic] == 'true'
      actions.more_polemic
    else
      actions.more_recent
    end
    actions
  end

  def get_private_actions(filters, current_user)
    actions = if current_user.present?
      self.private_actions.moderated_or_author_is(current_user)
    else
      self.private_actions.moderated
    end
    actions = actions.where(:event_type => [filters[:type]].flatten.map(&:camelize)) if filters[:type].present?

    actions = if filters[:more_polemic] == 'true'
      actions.more_polemic
    else
      actions.more_recent
    end
    actions
  end

  def get_questions(filters = {})
    questions = Question.from_politician(self, filters)
    questions = questions.answered if filters[:answered] == "true"

    questions = if filters[:more_polemic] == 'true'
      questions.more_polemic
    else
      questions.more_recent
    end
    questions
  end

  def get_proposals(filters, show_not_moderated = nil)
    if filters[:as_author]
      proposals = self.proposals
      proposals = proposals.moderated unless show_not_moderated
    else
      proposals = Proposal.user_is_author_or_participer(self, show_not_moderated)
    end

    proposals = proposals.from_politicians     if filters[:from_politicians]
    proposals = proposals.from_citizens        if filters[:from_citizens]

    proposals = if filters[:more_polemic] == 'true'
      proposals.more_polemic
    else
      proposals.more_recent
    end
    proposals
  end

  def fullname
    "#{name} #{lastname}".strip
  end

  def truncated_fullname(length = 40)
    fullname.truncate(length)
  end

  def location
    [city, province].compact.join(", ") if city.present? && province.present?
  end

  def thumbnail
    profile_image
  end

  def profile_image
    @profile_image ||= self.profile_picture.image.thumb.url if self.profile_picture.present?
  end

  def profile_image_big
    @profile_image_big ||= self.profile_picture.image.thumb_big.url if self.profile_picture.present?
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

  def agenda_between(weeks, filters)
    Event.from_area(self, weeks, filters)
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
    his_opinion(content).count == 0
  end

  def has_given_his_opinion?(content)
    his_opinion(content).count > 0
  end

  def his_opinion(content)
    case content
    when Question
      content.answer_requests.where('user_id = ?', id)
    when Proposal
      content.votes.where('user_id = ?', id)
    else
      []
    end
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
    User.includes(:role, :profile_picture, :title, :areas).politicians.where('users.id not in (?)', ([id] + users_following_ids))
  end

  def new_followers(last_seen_at)
    followers.where('follows.created_at > ?', last_seen_at || last_sign_in_at)
  end

  def notifications_count
    count = if politician?
      (new_proposals_count + new_questions_count + new_comments_count + new_arguments_count + new_votes_count + new_contents_users_count + new_follows_count) rescue 0
    elsif citizen?
      (new_answers_count + new_comments_count + new_arguments_count + new_votes_count + new_answer_requests_count) rescue 0
    else
      (new_answers_count + new_comments_count + new_arguments_count + new_votes_count + new_answer_requests_count) rescue 0
    end
    count = 99 if count > 99
    count
  end

  def notifications_grouped
    @notifications_grouped = []
    notifications.each do |n|
      last_added = @notifications_grouped.last.try(:last)
      if last_added.present? && last_added.attributes.slice('item_type', 'parent_id', 'parent_type') == n.attributes.slice('item_type', 'parent_id', 'parent_type')
        @notifications_grouped.last << n
      else
        @notifications_grouped << [n]
      end
    end
    @notifications_grouped.map{|n| [n.first, n.count]}.first(10)
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

  def destroy_exfollower_activity(exfollower)
    UserPrivateStream.joins(<<-SQL
      INNER JOIN contents ON contents.id = user_private_streams.event_id AND lower(contents.type) = user_private_streams.event_type
    SQL
    ).where('contents.user_id' => self.id, 'user_private_streams.user_id' => exfollower.id).destroy_all

    UserPrivateStream.joins(<<-SQL
      INNER JOIN participations ON participations.id = user_private_streams.event_id AND lower(participations.type) = user_private_streams.event_type
    SQL
    ).where('participations.user_id' => self.id, 'user_private_streams.user_id' => exfollower.id).destroy_all
  end

  def time_to_answer
    time = Answer.moderated.where('contents.user_id = ?', id).answer_time
    hours = time.to_i / 3600
    "%02dH" % hours
  end

  def comments_in_proposals
    comments.moderated.joins(:proposal)
  end

  #################################
  # COMPATIBILITY FOR IMPORTED USERS
  #################################

  def valid_password?(password)
    valid = false
    begin
      valid = super(password)
    rescue BCrypt::Errors::InvalidHash
      valid = old_user_authenticated?(password)
    end
    valid
  end

  def old_user_authenticated?(password)
    encrypted_password == Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  #################################
  # END - COMPATIBILITY FOR IMPORTED USERS
  #################################

  def just_created?
    name_was.nil? && lastname_was.nil? && valid?
  end

  def lastname_if_new_user
    if external_id.present?
      errors.add(:lastname, :blank) if lastname.nil? || lastname.length < 1
    else
      errors.add(:lastname, :blank) if lastname.blank?
    end
  end

  def update_counters
    update_attributes(
      :follows_count                 => follows.count,
      :areas_users_count             => areas_users.count,
      :proposals_count               => actions.proposals.count,
      :arguments_count               => actions.arguments.count,
      :votes_count                   => actions.votes.count,
      :questions_count               => actions.questions.count,
      :answers_count                 => actions.answers.count,
      :answer_requests_count         => actions.answer_requests.count,
      :events_count                  => actions.events.count,
      :news_count                    => actions.news.count,
      :photos_count                  => actions.photos.count,
      :videos_count                  => actions.videos.count,
      :status_messages_count         => actions.status_messages.count,
      :tweets_count                  => actions.tweets.count,
      :comments_count                => actions.comments.count,
      :private_proposals_count       => private_actions.proposals.count,
      :private_arguments_count       => private_actions.arguments.count,
      :private_votes_count           => private_actions.votes.count,
      :private_questions_count       => private_actions.questions.count,
      :private_answers_count         => private_actions.answers.count,
      :private_answer_requests_count => private_actions.answer_requests.count,
      :private_events_count          => private_actions.events.count,
      :private_news_count            => private_actions.news.count,
      :private_photos_count          => private_actions.photos.count,
      :private_videos_count          => private_actions.videos.count,
      :private_status_messages_count => private_actions.status_messages.count,
      :private_tweets_count          => private_actions.tweets.count,
      :private_comments_count        => private_actions.comments.count,
      :private_contents_users_count  => private_actions.contents_users.count
    )
  end

  def check_blank_name
    name = email if name.blank?
  end
  private :check_blank_name

  def check_user_role
    self.role = Role.citizen.first unless self.role.present?
  end
  private :check_user_role

  def default_follow
    if citizen?
      self.areas_following << Area.presidencia
      self.users_following = User.advisers.all
      self.users_following << User.patxi_lopez if User.patxi_lopez.present?
      save!
    end
  end
  private :default_follow

end
