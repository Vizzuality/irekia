class ParticipationsObserver < ActiveRecord::Observer
  observe :participation

  def after_commit(model)
    model.publish
    model.notify_content
  end

end
