class AnswerRequest < Participation

  belongs_to :question,
             :foreign_key => :content_id

  before_save :set_as_moderated
  after_save :update_question

  def self.find_or_initialize(params = nil)
    new_request = new(params)
    answer_request = User.find(params[:user_id]).answer_request(params[:content_id]).readonly(false).first if params.present?

    answer_request || new_request
  end

  def parent
    question
  end

  def set_as_moderated
    self.moderated = true
  end
  private :set_as_moderated

  def update_question
    (question || Question.find(content_id)).update_answer_requests_count if moderated?
  end
  private :update_question

  def notification_for(user)
    super(user)
    content.participers.where('participations.type' => 'AnswerRequest').each{|user| Notification.for(user, self)}
    if question.target_user
      Notification.for(question.target_user, self)
    elsif question.target_area
      question.target_area.team.each{|politician| Notification.for(politician, self)}
    end
  end
end
