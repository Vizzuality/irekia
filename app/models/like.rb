class Like < Participation

  def as_json(options = {})
    {
      :user          => {
        :id            => user.id,
        :name          => user.name,
        :profile_image => user.profile_image_thumb_url
      },
      :published_at    => published_at
    }
  end

end