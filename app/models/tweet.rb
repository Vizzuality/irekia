class Tweet < Content
  has_one :tweet_data

  delegate :message, :status_id, :username, :to => :tweet_data

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image
      },
      :published_at    => published_at,
      :message         => message,
      :status_id       => status_id,
      :username        => username
    }
  end
end
