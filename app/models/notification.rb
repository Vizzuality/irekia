class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :item,
             :polymorphic => true
  belongs_to :parent,
             :polymorphic => true

  after_create  :update_counter_cache
  after_destroy :update_counter_cache

  def self.for(user, item)
    find_or_create_by_user_id_and_item_type_and_item_id(user.id, item.class.name, item.id, :parent_id => item.parent.try(:id),
                                                                                           :parent_type => item.parent.try(:class).try(:name))
  end

  def update_counter_cache
    user.update_attribute("new_#{item_type.underscore.pluralize}_count", user.notifications.where(:item_type => item_type).count)
  end
  private :update_counter_cache
end
