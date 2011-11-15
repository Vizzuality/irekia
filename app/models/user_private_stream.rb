class UserPrivateStream < ActiveRecord::Base
  belongs_to :user

  after_create  :update_user_counters
  after_destroy :update_user_counters

  def self.questions
    where(:event_type => :question)
  end

  def self.answers
    where(:event_type => :answer)
  end

  def self.proposals
    where(:event_type => :proposal)
  end

  def self.votes
    where(:event_type => :vote)
  end

  def self.arguments
    where(:event_type => :argument)
  end

  def self.news
    where(:event_type => :news)
  end

  def self.photos
    where(:event_type => :photo)
  end

  def self.videos
    where(:event_type => :video)
  end

  def self.events
    where(:event_type => :event)
  end

  def self.status_messages
    where(:event_type => [:status_message, :tweet])
  end

  def self.comments
    where(:event_type => :comment)
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
                       AND user_public_streams.event_type IN ('question', 'answer', 'proposal', 'event', 'news', 'tweet')
    SQL
    ).order('comments_count.count desc, published_at desc')
  end

  def item
    JSON.parse(self.message).hashes2ostruct if self.message.present?
  rescue
  end

  def update_user_counters
    case
    when event_type == 'statusmessage' || event_type == 'tweet'
      user.update_attribute("private_statuses_count", user.private_actions.where(:event_type => %w(statusmessage tweet)).count)
    when event_type == 'answerrequest'
      user.update_attribute("private_questions_count", user.private_actions.where(:event_type => %w(questions answers answerrequest)).count)
    else
      user.update_attribute("private_#{event_type.pluralize}_count", user.private_actions.where(:event_type => event_type).count)
    end
  end
  private :update_user_counters
end
