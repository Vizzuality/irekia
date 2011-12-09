class ParticipationsObserver < ActiveRecord::Observer
  observe :participation, :comment_data, :argument_data, :vote_data, :answer_request

  def after_save(model)
    model.publish
  end

end
