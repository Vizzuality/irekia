class AreaPublicStream < ActiveRecord::Base
  include PgSearch

  belongs_to :area

  scope :this_week, lambda{ where('EXTRACT(WEEK FROM created_at) = ?', DateTime.now.cweek) }

  scope :only_contents, where(:event_type => [:proposal, :argument, :question, :answer, :news, :poll, :pollanswer, :event, :tweet, :photo])

  pg_search_scope :search, :against => :message

  def item
    JSON.parse(self.message).hashes2ostruct if self.message.present?
  rescue
  end
end
