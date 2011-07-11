class Comment < Participation
  belongs_to :content
  has_one :comment_data

  delegate :body, :to => :comment_data

  accepts_nested_attributes_for :comment_data

  def create_with_body(body)
    self.comment_data = CommentData.create :body => body
    self.save!
    self
  end

  def to_html

  end

end