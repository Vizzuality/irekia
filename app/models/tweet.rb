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

end
