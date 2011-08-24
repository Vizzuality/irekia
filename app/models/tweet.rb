class Tweet < Content
  has_one :tweet_data

  delegate :message, :status_id, :username, :to => :tweet_data

  def to_html

  end
end