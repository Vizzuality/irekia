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
    super({
      :body            => body
    })
  end

  def update_counter_cache
    return if content.blank?

    content.update_attribute('comments_count', content.comments.moderated.count)
    content.commenters.each { |user| user.update_attribute('comments_count', user.comments.moderated.count) }
  end
  private :update_counter_cache
end
