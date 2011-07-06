class Answer < Content
  has_one :answer_data

  delegate :answer_text, :to => :answer_data

  def to_html

  end
end
