class ContentUser < ActiveRecord::Base
  belongs_to :content
  belongs_to :user
  belongs_to :content_author,
             :foreign_key => :user_id,
             :class_name => 'User'
  belongs_to :content_receiver,
             :foreign_key => :user_id,
             :class_name => 'User'
  belongs_to :content_related_user,
             :foreign_key => :user_id,
             :class_name => 'User'
end
