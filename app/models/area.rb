class Area < ActiveRecord::Base
  include PgSearch
  extend FriendlyId

  friendly_id :name, :use => [:slugged, :simple_i18n]

  has_many :areas_users,
           :class_name => 'AreaUser'
  has_many :users,
           :through => :areas_users,
           :include => [:title, :role, :profile_picture],
           :select => 'users.id, users.name, users.lastname, users.title_id, users.role_id'
  has_many :team,
           :through => :areas_users,
           :source => :user,
           :select => 'users.id, users.email, users.name, users.lastname, users.title_id, users.role_id, users.slug, users.locale, display_order',
           :order => 'display_order ASC, external_id ASC'

  has_many :areas_contents,
           :class_name => 'AreaContent'
  has_many :contents_being_tagged,
           :through => :areas_contents
  has_many :news_being_tagged,
           :through => :areas_contents,
           :source => :news

  has_many :proposal_data,
           :class_name => 'ProposalData'
  has_many :proposals_received,
           :through => :proposal_data,
           :source => :proposal,
           :include => [{:users => [:profile_picture]}, :proposal_data, { :comments => [:author, :comment_data] }],
           :conditions => {:moderated => true},
           :order => 'published_at desc'

  has_many :actions,
           :class_name => 'AreaPublicStream',
           :select => 'event_id, event_type, message',
           :order => 'published_at desc'
  has_many :follows,
           :as => :follow_item
  has_many :followers,
           :through => :follows,
           :source => :user

  has_one :image

  accepts_nested_attributes_for :follows, :allow_destroy => true

  pg_search_scope :search_by_name,
                  :against => [:name, :name_es, :name_eu, :name_en],
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }
  pg_search_scope :search_by_name_and_description,
                  :against => [:name, :name_es, :name_eu, :name_en, :description],
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }

  def self.by_id(id)
    scoped.select([:id,
                   :name,
                   :name_es,
                   :name_eu,
                   :name_en,
                   :description,
                   :description_1,
                   :description_2,
                   :description_1_es,
                   :description_2_es,
                   :description_1_eu,
                   :description_2_eu,
                   :description_1_en,
                   :description_2_en,
                   :slug_es,
                   :slug_eu,
                   :slug_en,
                   :news_count,
                   :questions_count,
                   :answers_count,
                   :proposals_count,
                   :arguments_count,
                   :votes_count,
                   :photos_count,
                   :videos_count,
                   :status_messages_count,
                   :tweets_count
                   ]).where('slug_es = ? OR slug_eu = ? OR slug_en = ?', *([id] * 3)).first
  end

  def self.names_and_ids
    select([:id, :name, :name_es, :name_eu, :name_en, :slug_es, :slug_eu, :slug_en]).order('name asc')
  end

  def self.for_footer
    select([:id, :name,:name_es, :name_eu, :name_en, :slug_es, :slug_eu, :slug_en]).order('external_id asc')
  end

  def self.areas_for_homepage
    select([:'areas.id', :name,:name_es, :name_eu, :name_en, :slug_es, :slug_eu, :slug_en, :questions_count, :proposals_count])
    .order('created_at asc')
    .all
  end

  def self.presidencia
    where('external_id = ? OR name = ?', 1, 'Lehendakaritza').first
  end

  def lehendakaritza?
    external_id == 1
  end

  def name
    send("name_#{I18n.locale.to_s}") || send("name_#{I18n.default_locale.to_s}")
  end

  def description_1
    send("description_1_#{I18n.locale.to_s}") || send("description_1_#{I18n.default_locale.to_s}")
  end

  def description_2
    send("description_2_#{I18n.locale.to_s}") || send("description_2_#{I18n.default_locale.to_s}")
  end

  def create_action(item)
    public_action              = actions.find_or_create_by_event_id_and_event_type item.event_id, item.event_type
    public_action.published_at = item.published_at
    public_action.message      = item.message
    public_action.author_id    = item.author_id
    public_action.moderated    = item.moderated
    public_action.save!
  end
  alias create_public_action create_action

  def contents
    Content.joins(:author => :areas).where('areas.id' => self.id)
  end

  def participations
    Participation.joins(:author => :areas).where('areas.id' => self.id)
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

  def get_questions(filters, author)
    questions = Question.from_area(self, author)
    questions = questions.answered if filters[:answered]

    questions = if filters[:more_polemic] == 'true'
      questions.more_polemic
    else
      questions.more_recent
    end
    questions
  end

  def get_proposals(filters, author)
    proposals = Proposal.from_area(self, author)
    filter_proposals(proposals, filters)
  end

  def get_proposals_from_politician_areas(politician, filters)
    proposals = Proposal.from_politician_areas(self)
    filter_proposals(proposals, filters)
  end

  def filter_proposals(proposals, filters)
    proposals = proposals.from_politicians if filters[:from_politicians]
    proposals = proposals.from_citizens if filters[:from_citizens]

    proposals = if filters[:more_polemic] == 'true'
      proposals.more_polemic
    else
      proposals.more_recent
    end
    proposals
  end

  def agenda_between(weeks, filters)
    Event.from_area(self, weeks, filters)
  end

  def thumbnail
    image.image.thumb.url
  end

  def tweets
    Tweet.joins(:users => :areas).where('areas.id' => id).moderated
  end

  def status_messages
    StatusMessage.joins(:users => :areas).where('areas.id' => id).moderated
  end

  def destroy_exfollower_activity(exfollower)
    users.where('users.id not in (?)', exfollower.users_following_ids).each do |user|
      UserPrivateStream.joins(<<-SQL
        INNER JOIN contents ON contents.id = user_private_streams.event_id AND lower(contents.type) = user_private_streams.event_type
      SQL
      ).where('contents.user_id' => user.id, 'user_private_streams.user_id' => exfollower.id).destroy_all

      UserPrivateStream.joins(<<-SQL
        INNER JOIN participations ON participations.id = user_private_streams.event_id AND lower(participations.type) = user_private_streams.event_type
      SQL
      ).where('participations.user_id' => user.id, 'user_private_streams.user_id' => exfollower.id).destroy_all
    end
  end

  def update_counters
    update_attributes(
      :areas_users_count     => areas_users.count,
      :follows_count         => follows.count,
      :proposals_count       => actions.proposals.count,
      :arguments_count       => actions.arguments.count,
      :votes_count           => actions.votes.count,
      :questions_count       => actions.questions.count,
      :answers_count         => actions.answers.count,
      :answer_requests_count => actions.answer_requests.count,
      :events_count          => actions.events.count,
      :news_count            => actions.news.count,
      :photos_count          => actions.photos.count,
      :videos_count          => actions.videos.count,
      :status_messages_count => actions.status_messages.count,
      :tweets_count          => actions.tweets.count
    )
  end

end
