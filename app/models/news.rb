class News < Content
  has_one :news_data

  delegate :title, :subtitle, :body, :to => :news_data, :allow_nil => true

  def as_json(options = {})
    super({
      :title           => title,
      :subtitle        => subtitle,
      :body            => body
    })
  end

  def facebook_share_message
    title.truncate(140)
  end

  def twitter_share_message
    title.truncate(140)
  end

  def email_share_message
    title
  end

end
