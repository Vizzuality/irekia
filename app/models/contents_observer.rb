class ContentsObserver < ActiveRecord::Observer
  observe :content, :content_user

  def after_commit(model)
    model.publish if model.present?
  end
end
