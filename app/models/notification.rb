class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :item,
             :polymorphic => true
  belongs_to :parent,
             :polymorphic => true

  after_create  :increment_user_counter
  after_destroy :decrement_user_counter

  def self.for(user, item)
    create(:user_id     => user.id,
           :item_type   => item.class.name,
           :item_id     => item.id,
           :parent_id   => item.parent.try(:id),
           :parent_type => item.parent.try(:class).try(:name))
  end

  def increment_user_counter
    User.increment_counter("new_#{item.class.name.underscore.pluralize}_count", user_id)
  end
  private :increment_user_counter

  def decrement_user_counter
    User.decrement_counter("new_#{item.class.name.underscore.pluralize}_count", user_id) if item.present?
  end
  private :decrement_user_counter
end
