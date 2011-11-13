class Answer < Content
  belongs_to :question,
             :foreign_key => :related_content_id
  has_one :answer_data,
          :dependent => :destroy
  has_many :answer_opinions,
           :foreign_key => :content_id

  before_create :mark_question_as_answered

  delegate :answer_text, :to => :answer_data, :allow_nil => true
  delegate :question_text, :to => :question, :allow_nil => true

  accepts_nested_attributes_for :answer_opinions

  def self.from_area(area)
    joins(:author => :areas).moderated.where('areas.id' => area.id)
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

  def update_counter_cache
    return unless moderated?

    author.update_attribute("answers_count", author.actions.answers.count)
    author.followers.each{|user| user.update_attribute("private_answers_count", user.private_actions.answers.count)}
    author.areas.each do |area|
      area.update_attribute("answers_count", area.actions.answers.count)
    end
    Notification.for(question.author, self)
  end
  private :update_counter_cache

end
