class Comment < Participation
  belongs_to :content
  has_one :comment_data,
          :select => 'comment_id, body'

  delegate :subject, :body, :to => :comment_data, :allow_nil => true

  accepts_nested_attributes_for :comment_data

  def create_with_body(body)
    self.comment_data = CommentData.create :body => body
    self.save!
    self
  end

  def as_json(options = {})
    comment_content = content.parent.present?? content.parent : content
    super({
      :content => {
        :id   => comment_content.try(:id),
        :type => comment_content.try(:type).try(:underscore),
        :text => comment_content.try(:text)
      },
      :body => body
    })
  end

  def update_counter_cache
    return unless moderated?

    return if content.blank?

    content.update_attribute('comments_count', content.comments.moderated.count)
    content.commenters.each do |user|
      user.update_attribute('private_comments_count', user.private_actions.comments.count)
      Notification.for(user, self)
    end
    Notification.for(content.author, self)
    content.users.each{|user| Notification.for(user, self)}
  end
  private :update_counter_cache
end
