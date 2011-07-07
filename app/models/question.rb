class Question < Content
  has_one :question_data,
          :foreign_key => :question_id

  has_one :answer_data
  has_one :answer,
          :through => :answer_data

  scope :answered, joins(:answer)

  accepts_nested_attributes_for :question_data

  delegate :question_text, :to => :question_data

  def to_html

  end

end