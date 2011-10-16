class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :follow_item,
             :polymorphic => true

  scope :areas, where("follow_item_type = 'Area'")
  scope :users, where("follow_item_type = 'User'")

end
