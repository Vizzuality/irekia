class AreaPublicStream < ActiveRecord::Base
  include PgSearch

  paginates_per 4

  belongs_to :area

  scope :this_week, lambda{ where('EXTRACT(WEEK FROM published_at) = ?', DateTime.now.cweek) }

  scope :only_contents, where(:event_type => [:proposal, :argument, :question, :answer, :news, :poll, :pollanswer, :event, :tweet, :photo])

  scope :more_recent, order('published_at desc')

  scope :more_polemic, joins(<<-SQL
    INNER JOIN (
      SELECT p.content_id, count(p.content_id) AS count
      FROM contents c
      LEFT JOIN participations p ON p.content_id = c.id AND p.type = 'Comment'
      GROUP BY p.content_id
    ) comments_count ON comments_count.content_id = area_public_streams.event_id
                     AND area_public_streams.event_type IN ('question', 'answer', 'proposal', 'event', 'news', 'tweet')
  SQL
  ).order('comments_count.count desc, published_at desc')

  pg_search_scope :search, :against => :message

  def item
    JSON.parse(self.message).hashes2ostruct if self.message.present?
  rescue
  end
end
