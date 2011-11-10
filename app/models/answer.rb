class Answer < Content
  has_one :answer_data,
          :dependent => :destroy
  has_many :answer_opinions,
           :foreign_key => :content_id

  before_create :mark_question_as_answered

  delegate :question, :question_text, :answer_text, :to => :answer_data, :allow_nil => true

  accepts_nested_attributes_for :answer_opinions

  def as_json(options = {})
    super({
      :question_id     => question.try(:id),
      :question_text   => question_text,
      :answer_text     => answer_text
    })
  end

  def mark_question_as_answered
    question.mark_as_answered(published_at) if question
  end
  private :mark_question_as_answered

  def update_counter_cache
    users.each { |user| user.update_attribute("answers_count", user.answers.moderated.count) }
  end
  private :update_counter_cache

end
