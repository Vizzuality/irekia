class News < Content
  has_one :news_data

  delegate :title, :body, :to => :news_data

  def to_html

  end
end