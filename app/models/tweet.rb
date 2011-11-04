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
end
