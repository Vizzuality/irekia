class Area < ActiveRecord::Base
  include PgSearch

  has_many :areas_users,
           :class_name => 'AreaUser'
  has_many :users,
           :through => :areas_users,
           :include => [:title, :role, :profile_pictures],
           :select => 'users.id, users.name, users.lastname, users.title_id, users.role_id'
  has_many :team,
           :through => :areas_users,
           :source => :user,
           :select => 'users.id, users.name, users.lastname, users.title_id, users.role_id, display_order',
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
           :include => [{:users => [:profile_pictures]}, :proposal_data, { :comments => [:author, :comment_data] }],
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
                  :against => [:name],
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }
  pg_search_scope :search_by_name_and_description,
                  :against => [:name, :description],
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }

  def self.by_id(id)
    scoped.select([:id,
                   :name,
                   :description,
                   :description_1,
                   :description_2,
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
                   ]).find(id)
  end

  def self.names_and_ids
    select([:id, :name]).order('name asc')
  end

  def self.areas_for_homepage
    select([:'areas.id', :name, :questions_count, :proposals_count])
    .joins("LEFT JOIN (#{AreaPublicStream.select('area_id, max(published_at) date').group('area_id').order('date desc').to_sql}) aps ON aps.area_id = areas.id")
    .order('aps.date desc NULLS LAST')
    .page(1)
    .per(17)
    .all
  end

  def contents
    Content.joins(:author => :areas).where('areas.id' => self.id)
  end

  def participations
    Participation.joins(:author => :areas).where('areas.id' => self.id)
  end

  def get_actions(filters)
    actions = self.actions
    actions = actions.where(:event_type => [filters[:type]].flatten.map(&:camelize)) if filters[:type].present?

    actions = if filters[:more_polemic] == 'true'
      actions.more_polemic
    else
      actions.more_recent
    end

    actions
  end

  def get_questions(filters)
    questions = Question.from_area(self)
    questions = questions.answered if filters[:answered]

    questions = if filters[:more_polemic] == 'true'
      questions.more_polemic
    else
      questions.more_recent
    end
    questions
  end

  def get_proposals(filters)
    proposals = proposals_received
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

end
