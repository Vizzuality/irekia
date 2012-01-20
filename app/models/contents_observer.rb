class ContentsObserver < ActiveRecord::Observer
  observe :content, :content_user

  def after_commit(model)
    if model.present?
      model.publish
      model.send_notifications
      model.send_mail
    end
  end
end
