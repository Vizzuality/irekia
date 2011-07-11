class News < Content
  has_one :news_data

  delegate :title, :subtitle, :body, :to => :news_data

  def to_html

  end
end