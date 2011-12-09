class AnswerRequest < Participation

  belongs_to :question,
             :foreign_key => :content_id

  before_save :set_as_moderated
  after_save :update_question

  delegate :publish, :to => :question

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
      user_action              = question.target_user.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
      user_action.published_at = self.published_at
      user_action.message      = self.to_json
      user_action.save!

      question.target_user.areas.each do |area|
        area_action              = area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
        area_action.published_at = self.published_at
        area_action.message      = self.to_json
        area_action.save!
      end

    when question.target_area
      area_action              = question.target_area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
      area_action.published_at = self.published_at
      area_action.message      = self.to_json
      area_action.save!
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
