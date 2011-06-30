class AreaPublicStream < ActiveRecord::Base
  belongs_to :area

  scope :this_week, where('EXTRACT(WEEK FROM created_at) = ?', DateTime.now.cweek)
end
