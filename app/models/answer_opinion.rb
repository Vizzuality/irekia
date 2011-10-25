class AnswerOpinion < Participation
  belongs_to :answer,
             :foreign_key => :content_id

  has_one :answer_opinion_data


  delegate :satisfactory, :to => :answer_opinion_data

  accepts_nested_attributes_for :answer_opinion_data

  def self.satisfactory
    joins(:answer_opinion_data).where('answer_opinion_data.satisfactory' => true)
  end

  def self.not_satisfactory
    joins(:answer_opinion_data).where('answer_opinion_data.satisfactory' => false)
  end

  def as_json(options = {})
    {
      :author          => {
        :id            => user.id,
        :name          => user.name,
        :fullname      => user.fullname,
        :profile_image => user.profile_image
      },
      :published_at    => published_at,
      :satisfactory    => satisfactory
    }
  end

end
