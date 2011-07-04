class Question < Content
  has_many :answers,
           :foreign_key => :related_content_id

  scope :answered, joins(:answers)

  def to_s
    self.title
  end
end