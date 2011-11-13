class AnswerRequest < Participation

  belongs_to :question,
             :foreign_key => :content_id

  before_save :set_as_moderated
  after_save :update_question

  def self.find_or_initialize(params = nil)
    new_request = new(params)
    answer_request = User.find(params[:user_id]).answer_request(params[:content_id]).first if params.present?

    answer_request || new_request
  end

  def set_as_moderated
    self.moderated = true
  end
  private :set_as_moderated

  def update_question
    (question || Question.find(content_id)).update_answer_requests_count if moderated?
  end
  private :update_question

  def update_counter_cache
    return unless moderated?

    Notification.for(content.author, self)
  end
  private :update_counter_cache

end
