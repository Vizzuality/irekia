class AnswerRequest < Participation

  belongs_to :question,
             :counter_cache => true

  def self.find_or_initialize(params = nil)
    new_request = new(params)
    answer_request = User.find(params[:user_id]).answer_request(params[:content_id]).first if params.present?

    answer_request || new_request
  end

end
