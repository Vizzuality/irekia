class AnswerData < ActiveRecord::Base

  belongs_to :question,
             :foreign_key => :question_id

  belongs_to :answer,
             :foreign_key => :answer_id

  belongs_to :author,
             :class_name => 'User',
             :foreign_key => :user_id

  delegate :question_text, :to => :question
end
