class PollAnswer < Content
  belongs_to :poll_question,
             :foreign_key => :related_content_id

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :fullname      => author.fullname,
        :profile_image => author.profile_image
      },
      :published_at    => published_at,
      :comments_count  => comments_count
    }
  end
end
