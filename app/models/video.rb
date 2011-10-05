class Video < Content

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
      :last_comments   => comments.last(2)
    }
  end

end
