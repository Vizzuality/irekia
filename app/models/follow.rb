class Follow < ActiveRecord::Base
  belongs_to :user,
             :counter_cache => true
  belongs_to :follow_item,
             :polymorphic => true,
             :counter_cache => true

  scope :areas, where("follow_item_type = 'Area'")
  scope :users, where("follow_item_type = 'User'")

end
