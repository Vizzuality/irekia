class UserPublicStream < ActiveRecord::Base
  belongs_to :user

  scope :this_week, lambda{ where('EXTRACT(WEEK FROM created_at) = ?', DateTime.now.cweek) }
end
