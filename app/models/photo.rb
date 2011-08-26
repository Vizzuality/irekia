class Photo < Content
  has_one :image

  delegate :title, :description, :original_url, :content_url, :to => :image

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image_thumb_url
      },
      :published_at    => published_at,
      :title           => title,
      :description     => description,
      :content_url     => content_url,
      :comments        => comments.count
    }
  end
end