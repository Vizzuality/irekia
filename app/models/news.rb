class News < Content
  has_one :news_data

  delegate :title, :subtitle, :body, :to => :news_data

  def as_json(options = {})
    super({
      :title           => title,
      :subtitle        => subtitle,
      :body            => body
    })
  end
end
