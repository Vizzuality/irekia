class AreaPublicStream < ActiveRecord::Base
  include PgSearch

  belongs_to :area

  scope :this_week, lambda{ where('EXTRACT(WEEK FROM created_at) = ?', DateTime.now.cweek) }

  scope :only_contents, where(:event_type => [:proposal, :argument, :question, :answer, :news, :poll, :pollanswer, :event, :tweet, :photo])

  pg_search_scope :search_in_all_contents, :against => [:message]

  def item
    OpenStruct.new JSON.parse(self.message) if self.message.present?
  rescue
  end
end
