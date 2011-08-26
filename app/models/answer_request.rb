class AnswerRequest < Participation

  def as_json(options = {})
    {
      :author          => {
        :id            => user.id,
        :name          => user.name,
        :profile_image => user.profile_image
      },
      :published_at    => published_at
    }
  end

end
