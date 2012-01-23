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
    @to_update_public_streams  = (to_update_public_streams || [])
    @to_update_private_streams = (to_update_private_streams || [])

    case
    when question.target_user
      @to_update_public_streams << question.target_user
      @to_update_public_streams += question.target_user.areas

      @to_update_private_streams << question.target_user
    when question.target_area
      @to_update_public_streams << question.target_area
      @to_update_public_streams += question.target_area.team
    end

    super
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
