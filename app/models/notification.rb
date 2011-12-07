class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :item,
             :polymorphic => true
  belongs_to :parent,
             :polymorphic => true

  after_create  :increment_user_counter
  after_destroy :decrement_user_counter

  def self.for(user, item)
    find_or_create_by_user_id_and_item_type_and_item_id(user.id, item.class.name, item.id, :parent_id => item.parent.try(:id),
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
