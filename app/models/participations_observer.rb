class ParticipationsObserver < ActiveRecord::Observer
  observe :comment_data, :argument_data, :vote_data, :answer_request

  def after_save(model)
    model.publish
  end

end
