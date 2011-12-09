class CommentData < ActiveRecord::Base
  belongs_to :comment

  delegate :publish, :to => :comment

end
