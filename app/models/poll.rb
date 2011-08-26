class Poll < Content
  has_one :question

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image_thumb_url
      },
      :published_at    => published_at,
      :comments        => comments.count
    }
  end
end