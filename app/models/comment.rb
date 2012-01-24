class Comment < Participation
  belongs_to :content
  belongs_to :proposal,
             :foreign_key => 'content_id'
  has_one :comment_data,
          :select => 'comment_id, body'

  delegate :subject, :body, :to => :comment_data, :allow_nil => true

  accepts_nested_attributes_for :comment_data

  def self.moderated_or_author_is(user)
    where('(moderated = ? OR (moderated = ? AND user_id = ?))', true, false, user.id)
  end

  def self.this_week
    where('EXTRACT(WEEK FROM participations.published_at) = ?', DateTime.now.cweek)
  end

  def create_with_body(body)
    self.comment_data = CommentData.create :body => body
    self.save!
    self
  end

  def as_json(options = {})
    comment_content = content.parent.present?? content.parent : content
    super({
      :content => comment_content.as_json,
      :body => body
    })
  end

  def publish

    return if self.author.blank?

    @to_update_private_streams = (to_update_private_streams || [])
    @to_notificate             = (to_notificate || [])

    @to_update_private_streams += content.participers(author).where('participations.type' => 'Comment')
    @to_notificate             += content.participers(author).where('participations.type' => 'Comment')

    super
  end

end
