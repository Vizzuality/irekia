class AnswerOpinion < Participation
  belongs_to :answer,
             :foreign_key => :content_id

  has_one :answer_opinion_data


  delegate :satisfactory, :to => :answer_opinion_data, :allow_nil => true

  accepts_nested_attributes_for :answer_opinion_data

  def self.satisfactory
    joins(:answer_opinion_data).where('answer_opinion_data.satisfactory' => true)
  end

  def self.not_satisfactory
    joins(:answer_opinion_data).where('answer_opinion_data.satisfactory' => false)
  end

  def parent
    answer
  end

  def as_json(options = {})
    super({
      :satisfactory    => satisfactory
    })
  end

end
