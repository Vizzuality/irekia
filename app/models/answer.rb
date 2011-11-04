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
      :question_id     => answer_data.question_id,
      :question_text   => answer_data.question_text,
      :answer_text     => answer_text
    })
  end

  def publish_content

    return unless self.moderated?

    author = question.author
    User.increment_counter('answers_count', author.id)
    super
  end
  private :publish_content

  def mark_question_as_answered
    question.mark_as_answered(published_at) if question
  end
  private :mark_question_as_answered
end
