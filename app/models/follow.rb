class Follow < ActiveRecord::Base
  belongs_to :user,
             :counter_cache => true
  belongs_to :follow_item,
             :polymorphic => true,
             :counter_cache => true

  def self.areas
    where("follow_item_type = 'Area'")
  end

  def self.users
    where("follow_item_type = 'User'")
  end

end
