class ContentUser < ActiveRecord::Base
  belongs_to :content
  belongs_to :user
  belongs_to :news,           :foreign_key => :content_id
  belongs_to :photos,         :foreign_key => :content_id
  belongs_to :videos,         :foreign_key => :content_id
  belongs_to :question,       :foreign_key => :content_id
  belongs_to :answer,         :foreign_key => :content_id
  belongs_to :proposal,       :foreign_key => :content_id
  belongs_to :event,          :foreign_key => :content_id
  belongs_to :tweet,          :foreign_key => :content_id
  belongs_to :status_message, :foreign_key => :content_id

  accepts_nested_attributes_for :question, :user

  after_save :update_counter_cache

  def parent
    content
  end

  def update_counter_cache
    return unless content && content.moderated?

    Notification.for(user, self)
  end
  private :update_counter_cache
end
