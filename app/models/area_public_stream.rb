class AreaPublicStream < ActiveRecord::Base
  include PgSearch

  belongs_to :area

  after_create  :increment_user_counter
  after_destroy :decrement_user_counter

  pg_search_scope :search,
                  :against => :message,
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }

  def self.for_homepage
    select('distinct on(event_id, event_type) *')
  end

  def self.this_week
    where('EXTRACT(WEEK FROM published_at) = ?', DateTime.now.cweek)
  end

  def self.only_contents
    where(:event_type => %w(Proposal Argument Question Answer News Event Tweet Photo))
  end

  def self.questions
    where(:event_type => 'Question')
  end

  def self.answers
    where(:event_type => 'Answer')
  end

  def self.proposals
    where(:event_type => 'Proposal')
  end

  def self.votes
    where(:event_type => 'Vote')
  end

  def self.arguments
    where(:event_type => 'Argument')
  end

  def self.news
    where(:event_type => 'News')
  end

  def self.photos
    where(:event_type => 'Photo')
  end

  def self.videos
    where(:event_type => 'Video')
  end

  def self.events
    where(:event_type => 'Event')
  end

  def self.status_messages
    where(:event_type => 'StatusMessage')
  end

  def self.tweets
    where(:event_type => 'Tweet')
  end

  def self.comments
    where(:event_type => 'Comment')
  end

  def self.more_recent
    order('published_at desc')
  end

  def self.more_polemic
    joins(<<-SQL
      INNER JOIN (
        SELECT p.content_id, count(p.content_id) AS count
        FROM contents c
        LEFT JOIN participations p ON p.content_id = c.id AND p.type = 'Comment'
        GROUP BY p.content_id
      ) comments_count ON comments_count.content_id = area_public_streams.event_id
                       AND area_public_streams.event_type IN ('Question', 'Answer', 'Proposal', 'Event', 'News', 'Tweet')
    SQL
    ).order('comments_count.count desc, published_at desc')
  end

  def item
    JSON.parse(self.message).hashes2ostruct if self.message.present?
  rescue
  end

  def increment_user_counter
    Area.increment_counter("#{event_type.underscore.pluralize}_count", area_id)
  end
  private :increment_user_counter

  def decrement_user_counter
    Area.decrement_counter("#{event_type.underscore.pluralize}_count", area_id)
  end
  private :decrement_user_counter

end
