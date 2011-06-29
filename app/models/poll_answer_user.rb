class PollAnswerUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :poll_answer
end
