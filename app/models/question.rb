class Question < Content
  has_one :question_data,
          :include => :target_user

  has_one :answer_data
  has_one :answer,
          :through => :answer_data

  scope :answered, joins(:answer)

  delegate :question_text, :to => :question_data

  def to_html

  end

  def to_s
    self.title
  end
end