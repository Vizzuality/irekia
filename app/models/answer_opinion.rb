class AnswerOpinion < Participation
  belongs_to :answer,
             :foreign_key => :content_id

  has_one :answer_opinion_data

  scope :satisfactory, joins(:answer_opinion_data).where('answer_opinion_data.satisfactory' => true)
  scope :not_satisfactory, joins(:answer_opinion_data).where('answer_opinion_data.satisfactory' => false)

  accepts_nested_attributes_for :answer_opinion_data

end