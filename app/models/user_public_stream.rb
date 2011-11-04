class UserPublicStream < ActiveRecord::Base
  belongs_to :user

  def self.this_week
    where('EXTRACT(WEEK FROM published_at) = ?', DateTime.now.cweek)
  end

  def self.more_recent
    order('published_at asc')
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
    ).order('comments_count.count desc, published_at asc')
  end

  def item
    JSON.parse(self.message).hashes2ostruct if self.message.present?
  rescue
  end
end
