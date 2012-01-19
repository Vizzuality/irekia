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

  def as_json(options = {})
    super({
      :question_text         => question.question_text,
      :answer_requests_count => question.answer_requests_count
    })
  end

  def publish
    super

    case
    when question.target_user
      question.target_user.create_public_action(self)
      question.target_user.areas.each{|area| area.create_action(self)}
      @users_to_notificate << question.target_user
    when question.target_area
      question.target_area.create_action(self)
      question.target_area.team.each{|politician| politician.create_public_action(self)}
    end
  end

  def set_as_moderated
    self.moderated = true
  end
  private :set_as_moderated

  def update_question
    (question || Question.find(content_id)).update_answer_requests_count if moderated?
  end
  private :update_question

end
