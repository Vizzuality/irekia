class Follow < ActiveRecord::Base
  belongs_to :user,
             :counter_cache => true
  belongs_to :follow_item,
             :polymorphic => true,
             :counter_cache => true

  validate :user_already_following_this_item?

  after_create   :update_follower_activity
  after_destroy  :destroy_exfollower_activity

  def self.areas
    where("follow_item_type = 'Area'")
  end

  def self.users
    where("follow_item_type = 'User'")
  end

  def parent
    user
  end

  def user_already_following_this_item?
    return if user.not_following(follow_item)
    errors[:already_following] = "You're already following this item"
  end
  private :user_already_following_this_item?

  def send_notification
    Notification.for(follow_item, self) if follow_item.is_a?(User)
  end

  def update_follower_activity
    follow_item.contents.where('published_at > ?', 5.day.ago).each do |content|
      user.create_private_action(content)
    end
    follow_item.participations.where('published_at > ?', 5.day.ago).each do |participation|
      user.create_private_action(participation)
    end
  end
  private :update_follower_activity

  def destroy_exfollower_activity
    follow_item.destroy_exfollower_activity(user)
  end
  private :destroy_exfollower_activity
end
