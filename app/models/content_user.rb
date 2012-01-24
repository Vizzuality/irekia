class ContentUser < ActiveRecord::Base
  include Irekia::StreamsUpdater

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

  delegate :moderated, :to => :content, :allow_nil => true

  accepts_nested_attributes_for :question, :user

  def published_at
    updated_at
  end

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

  def publish
    return if content.blank? || self.destroyed?

    @to_update_private_streams = content.tagged_politicians
    @to_notificate             = content.tagged_politicians

    update_streams
  end

  def send_notifications
    # This notification shouldn't be sent
    # Notification.for(user, self)
  end

end
