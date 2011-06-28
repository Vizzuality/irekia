class Answer < ActiveRecord::Base
  belongs_to :question

  has_many :users, :class_name => 'AnswerUser'
end
