class Answer < Content
  has_one :answer_data,
          :dependent => :destroy
  has_many :answer_opinions,
           :foreign_key => :content_id


  delegate :question, :question_text, :answer_text, :to => :answer_data

  accepts_nested_attributes_for :answer_opinions

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
      :question_text   => answer_data.question_text,
      :answer_text     => answer_text,
      :comments_count  => comments_count,
      :last_comments   => last_comments
    }
  end

  def publish_content

    return unless self.moderated?

    author = question.author
    author.update_attribute('answers_count', author.answers_count + 1)
    super
  end
  private :publish_content
end
