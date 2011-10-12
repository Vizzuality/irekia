class Poll < Content
  has_one :question

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
      :comments_count  => comments_count,
      :last_comments   => last_comments
    }
  end
end
