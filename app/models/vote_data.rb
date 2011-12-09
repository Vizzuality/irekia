class VoteData < ActiveRecord::Base
  belongs_to :vote,
             :foreign_key => :vote_id

  delegate :publish, :to => :vote

  def against
    !in_favor
  end
end
