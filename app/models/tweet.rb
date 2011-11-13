class Tweet < Content
  has_one :tweet_data

  delegate :message, :status_id, :username, :to => :tweet_data, :allow_nil => true

  def self.from_area(area)
    joins(:author => :areas).moderated.where('areas.id' => area.id)
  end

  def text
    message
  end

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
    return unless moderated?

    author.update_attribute("statuses_count", author.actions.status_messages.count)
    author.followers.each{|user| user.update_attribute("private_statuses_count", user.private_actions.status_messages.count)}
    author.areas.each{|area| area.update_attribute("statuses_count", area.actions.status_messages.count)}
  end
  private :update_counter_cache

end
