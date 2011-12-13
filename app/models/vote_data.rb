class VoteData < ActiveRecord::Base

  belongs_to :vote,
             :foreign_key => :vote_id

  def against
    !in_favor
  end

end
