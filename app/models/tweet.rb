class Tweet < Content
  has_one :tweet_data

  delegate :message, :status_id, :username, :to => :tweet_data, :allow_nil => true

  def as_json(options = {})
    super({
      :message         => message,
      :status_id       => status_id,
      :username        => username
    })
  end

  def facebook_share_message
    message.truncate(140)
  end

  def twitter_share_message
    message.truncate(140)
  end

  def email_share_message
    message
  end

  def update_counter_cache
    areas.each { |area| area.update_attribute("statuses_count", (area.status_messages.count + area.tweets.count)) }
    users.each { |user| user.update_attribute("statuses_count", (user.status_messages.moderated.count + user.tweets.moderated.count)) }
  end
  private :update_counter_cache

end
