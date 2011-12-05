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

  after_save :publish
  after_save :send_notification

  def parent
    content
  end

  def as_json(options = {})
    content_author = {
      :id            => content.author.id,
      :name          => content.author.name,
      :fullname      => content.author.fullname,
      :profile_image => content.author.profile_image,
      :is_politician => content.author.politician?
    } if content.author.present?

    default = {
      :author          => content_author,
      :id              => id,
      :content         => {
        :id    => content.id,
        :type  => content.type.underscore,
        :title => content.text
      },
      :content_type    => self.class.name,
      :published_at    => content.published_at,
      :tags            => content.tags,
      :comments_count  => content.comments_count,
      :last_comments   => content.last_comments
    }

    default.merge(options || {})
  end

  def notification_for(user)
    content.tagged_politicians.each{|politician| Notification.for(politician, self)}
  end

  def publish

    return unless self.content.moderated? && self.content.author.present?

    content.tagged_politicians.each do |politician|
      user_action              = politician.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
      user_action.published_at = self.updated_at
      user_action.message      = self.to_json
      user_action.save!
    end

  end
  private :publish

  def send_notification
    return unless content && content.moderated?

    Notification.for(user, self)
  end
  private :send_notification
end
