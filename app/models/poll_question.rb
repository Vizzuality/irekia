class PollQuestion < ActiveRecord::Base
  belongs_to :poll

  has_many :poll_answers
end
