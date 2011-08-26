class UserPrivateStream < ActiveRecord::Base
  belongs_to :user

  def item
    JSON.parse(self.message).hashes2ostruct if self.message.present?
  rescue
  end
end
