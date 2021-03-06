class ParticipationsObserver < ActiveRecord::Observer
  observe :participation

  def after_create(model)
    model.just_created   = true
  end

  def after_commit(model)
    if model.present?
      model.publish
      model.notify_content
    end
  end

end
