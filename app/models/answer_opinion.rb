class AnswerOpinion < Participation
  belongs_to :answer,
             :foreign_key => :content_id

  has_one :answer_opinion_data

  scope :satisfactory, joins(:answer_opinion_data).where('answer_opinion_data.satisfactory' => true)
  scope :not_satisfactory, joins(:answer_opinion_data).where('answer_opinion_data.satisfactory' => false)

  delegates :satisfactory, :to => :answer_opinion_data

  accepts_nested_attributes_for :answer_opinion_data

  def as_json(options = {})
    {
      :user            => {
        :id            => user.id,
        :name          => user.name,
        :profile_image => user.profile_image_thumb_url
      },
      :published_at    => published_at,
      :satisfactory    => satisfactory
    }
  end

end