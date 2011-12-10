class ContentsObserver < ActiveRecord::Observer
  observe :content

  def after_commit(model)
    model.publish if model.present?
  end
end
