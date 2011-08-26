class Photo < Content
  has_one :image

  delegate :title, :description, :original_url, :content_url, :to => :image

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image
      },
      :published_at    => published_at,
      :title           => title,
      :description     => description,
      :content_url     => content_url,
      :comments_count  => comments_count
    }
  end
end