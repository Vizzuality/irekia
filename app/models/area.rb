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
           :order => 'display_order ASC'

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

  pg_search_scope :search_by_name_and_description,
                  :against => [:name, :description],
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }

  def self.by_id(id)
    scoped.select([:id,
                   :name,
                   :description,
                   :news_count,
                   :questions_count,
                   :answers_count,
                   :proposals_count,
                   :arguments_count,
                   :votes_count,
                   :photos_count,
                   :videos_count,
                   :statuses_count
                   ]).find(id)
  end

  def self.names_and_ids
    select([:id, :name])
  end

  def get_actions(filters)
    actions = self.actions
    actions = actions.where(:event_type => filters[:type]) if filters[:type].present?

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
    calendar_date = Date.current
    if filters[:next_month].present?
      calendar_date = Date.current.advance(:months => filters[:next_month].to_i)
    end

    beginning_of_calendar = calendar_date.beginning_of_week
    end_of_calendar = calendar_date.advance(:weeks => weeks).end_of_week

    events = Event.from_area(self, beginning_of_calendar, end_of_calendar)

    agenda      = events.group_by{|e| e.event_date.day }
    days        = beginning_of_calendar..end_of_calendar
    agenda_json = JSON.generate(events.map{|event| {
      :title => event.title,
      :date  => I18n.localize(event.event_date, :format => '%d, %B de %Y'),
      :when  => event.event_date.strftime('%H:%M'),
      :where => nil,
      :lat   => event.latitude,
      :lon   => event.longitude
    }}.group_by{|event| [event[:lat], event[:lon]]}.values).html_safe

    return agenda, days, agenda_json
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
end
