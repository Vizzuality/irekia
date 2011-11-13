class Follow < ActiveRecord::Base
  belongs_to :user,
             :counter_cache => true
  belongs_to :follow_item,
             :polymorphic => true,
             :counter_cache => true

  validate :user_already_following_this_item?

  after_create :update_counter_cache

  def self.areas
    where("follow_item_type = 'Area'")
  end

  def self.users
    where("follow_item_type = 'User'")
  end

  def user_already_following_this_item?
    return if user.not_following(follow_item)
    errors[:already_following] = "You're already following this item"
  end
  private :user_already_following_this_item?

  def update_counter_cache
    Notification.for(user, self)
  end
  private :update_counter_cache
end
