class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :follow_item, :polymorphic => true
end
