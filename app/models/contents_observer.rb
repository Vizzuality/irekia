class ContentsObserver < ActiveRecord::Observer
  observe :answer_data, :event_data, :image, :news_data, :proposal_data, :question_data, :status_message_data, :tweet_data, :video_data

  def after_save(model)
    model.publish if model.present?
  end
end
