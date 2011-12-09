class CommentData < ActiveRecord::Base
  belongs_to :comment

  def publish
    comment.publish if comment.present?
  end
end
