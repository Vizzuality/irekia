class AnswerRequest < Participation

  belongs_to :question,
             :counter_cache => true

  def as_json(options = {})
    {
      :author          => {
        :id            => user.id,
        :name          => user.name,
        :fullname      => user.fullname,
        :profile_image => user.profile_image
      },
      :published_at    => published_at
    }
  end

end
