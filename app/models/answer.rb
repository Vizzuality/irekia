class Answer < Content
  belongs_to :question,
             :foreign_key => :related_content_id
  has_one :answer_data,
          :dependent => :destroy

  before_create :mark_question_as_answered

  delegate :answer_text, :to => :answer_data, :allow_nil => true
  delegate :question_text, :to => :question, :allow_nil => true

  accepts_nested_attributes_for :answer_data

  def self.from_area(area)
    joins(:author => :areas).moderated.where('areas.id' => area.id)
  end

  def parent
    question
  end

  def text
    answer_text
  end

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

  def notification_for(user)
    Notification.for(question.author, self)
    question.answer_requests.map(&:author).each{|user| Notification.for(user, self)}
  end

end
