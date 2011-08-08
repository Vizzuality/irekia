class AreaPublicStream < ActiveRecord::Base
  belongs_to :area

  scope :this_week, lambda{ where('EXTRACT(WEEK FROM created_at) = ?', DateTime.now.cweek) }
end
