class Question < Content
  has_one :question_data,
          :foreign_key => :question_id

  has_one :answer_data
  has_one :answer,
          :through => :answer_data
  has_many :answer_requests,
           :foreign_key => :content_id

  scope :answered, joins(:answer)
  scope :not_answered, includes(:answer_data).where('answer_data.question_id IS NULL')

  accepts_nested_attributes_for :question_data, :answer_requests, :answer

  delegate :question_text, :to => :question_data

  def to_html

  end

end