class News < Content
  has_one :news_data

  delegate :title, :subtitle, :body, :to => :news_data

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :fullname      => author.fullname,
        :profile_image => author.profile_image
      },
      :id              => id,
      :published_at    => published_at,
      :title           => title,
      :subtitle        => subtitle,
      :body            => body,
      :comments_count  => comments_count,
      :last_comments   => comments.last(2)
    }
  end
end
