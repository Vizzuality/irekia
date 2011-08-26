class News < Content
  has_one :news_data

  delegate :title, :subtitle, :body, :to => :news_data

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image_thumb_url
      },
      :published_at    => published_at,
      :title           => title,
      :subtitle        => subtitle,
      :body            => body,
      :comments        => comments.count
    }
  end
end
