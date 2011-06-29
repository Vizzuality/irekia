class PollAnswer < ActiveRecord::Base
  belongs_to :poll_question

  has_many :users, :class_name => 'PollAnswerUser'
end
