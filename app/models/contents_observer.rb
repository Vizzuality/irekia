class ContentsObserver < ActiveRecord::Observer
  observe :content, :content_user

  def after_create(model)
    model.just_created   = true
  end

  def after_commit(model)
    if model.present?
      model.publish
    end
  end
end
