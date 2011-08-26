class UserPublicStream < ActiveRecord::Base
  belongs_to :user

  scope :this_week, lambda{ where('EXTRACT(WEEK FROM created_at) = ?', DateTime.now.cweek) }

  def item
    JSON.parse(self.message).hashes2ostruct if self.message.present?
  rescue
  end
end
