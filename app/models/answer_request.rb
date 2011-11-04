class AnswerRequest < Participation

  belongs_to :question,
             :counter_cache => true

end
