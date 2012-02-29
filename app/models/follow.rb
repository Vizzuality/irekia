class Follow < ActiveRecord::Base
  belongs_to :user,
             :counter_cache => true
  belongs_to :follow_item,
             :polymorphic => true,
             :counter_cache => true

  validate :user_already_following_this_item?

  after_create   :send_notification
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
    return if user.present? && user.not_following(follow_item)
    errors[:already_following] = "You're already following this item"
  end
  private :user_already_following_this_item?

  def send_notification
    Notification.for(follow_item, self) if follow_item.is_a?(User)
  end

  def update_follower_activity
    follow_item.actions.where('published_at > ?', 1.day.ago).each do |action|
      UserPrivateStream.transaction do
        user.private_actions.create(
          :event_type   => action.event_type,
          :event_id     => action.event_id,
          :published_at => action.published_at,
          :message      => action.message,
          :moderated    => action.moderated
        )
      end
    end
  end
  private :update_follower_activity

  def destroy_exfollower_activity
    follow_item.destroy_exfollower_activity(user)
  end
  private :destroy_exfollower_activity
end
