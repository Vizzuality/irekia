class AnswerData < ActiveRecord::Base
  belongs_to :answer,
             :foreign_key => :answer_id

end
