class Area < ActiveRecord::Base
  include PgSearch

  has_many :areas_users,
           :class_name => 'AreaUser'
  has_many :users,
           :through => :areas_users,
           :include => [:title, :role, :profile_pictures],
           :select => 'users.id, users.name, users.lastname'
  has_many :team,
           :through => :areas_users,
           :source => :user,
           :order => 'display_order ASC'
  has_many :areas_contents,
           :class_name => 'AreaContent'
  has_many :contents,
           :through => :areas_contents
  has_many :questions,
           :through => :areas_contents,
           :include => [{:users => :profile_pictures}, :question_data, :comments ],
           :select => 'contents.id, contents.type, contents.published_at, contents.moderated',
           :order => 'published_at asc'
  has_many :proposals,
           :through => :areas_contents,
           :include => [{:users => :profile_pictures}, :proposal_data, { :comments => [:author, :comment_data] }],
           :select => 'contents.id, contents.type, contents.published_at, contents.moderated',
           :order => 'published_at asc'

  has_many :news,
           :through => :areas_contents,
           :include => [{:users => [:role, :profile_pictures]}, :news_data, :comments]
  has_many :videos,
           :through => :areas_contents,
           :include => [{:users => [:role, :profile_pictures]}, :comments]
  has_many :photos,
           :through => :areas_contents,
           :include => [{:users => [:role, :profile_pictures]}, :comments]
  has_many :events,
           :through => :areas_contents,
           :include => :event_data,
           :select => 'event_date, duration, title, subtitle, body',
           :order => 'event_data.event_date asc'

  has_many :proposal_data,
           :class_name => 'ProposalData'
  has_many :proposals_received,
           :through => :proposal_data,
           :source => :proposal,
           :include => [{:users => [:profile_pictures]}, :proposal_data, { :comments => [:author, :comment_data] }]

  has_many :actions,
           :class_name => 'AreaPublicStream',
           :select => 'event_id, event_type, message',
           :order => 'published_at asc'
  has_many :follows,
           :as => :follow_item
  has_many :followers,
           :through => :follows,
           :source => :user

  accepts_nested_attributes_for :questions
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
                           :follows_count,
                           :news_count,
                           :questions_count,
                           :proposals_count,
                           :photos_count,
                           :videos_count]).find(id)
  end

  def self.names_and_ids
    select([:id, :name])
  end

  def agenda_between(start_date, end_date)
    events.moderated.where('event_data.event_date >= ? AND event_data.event_date <= ?', start_date, end_date)
  end
end
