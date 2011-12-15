class Comment < Participation
  belongs_to :content
  has_one :comment_data,
          :select => 'comment_id, body'

  delegate :subject, :body, :to => :comment_data, :allow_nil => true

  accepts_nested_attributes_for :comment_data

  def self.moderated_or_author_is(user)
    where('(moderated = ? OR (moderated = ? AND user_id = ?))', true, false, user.id)
  end

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

end
