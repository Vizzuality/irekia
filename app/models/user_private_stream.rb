class UserPrivateStream < ActiveRecord::Base
  belongs_to :user
  belongs_to :event,
             :polymorphic => true
  after_save    :send_notification
  after_create  :increment_user_counter
  after_destroy :decrement_user_counter

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
    where(:event_type => %w(StatusMessage Tweet))
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
      ) comments_count ON comments_count.content_id = user_public_streams.event_id
                       AND user_public_streams.event_type IN ('Question', 'Answer', 'Proposal', 'Event', 'News', 'Tweet')
    SQL
    ).order('comments_count.count desc, published_at desc')
  end

  def item
    JSON.parse(self.message).hashes2ostruct if self.message.present?
  rescue
  end

  def send_notification
    Notification.for(user, event)
  end
  private :send_notification

  def increment_user_counter
    User.increment_counter("private_#{event_type.underscore.pluralize}_count", user_id)
  end
  private :increment_user_counter

  def decrement_user_counter
    User.decrement_counter("private_#{event_type.underscore.pluralize}_count", user_id)
  end
  private :decrement_user_counter

end
