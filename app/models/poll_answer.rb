class PollAnswer < Content
  belongs_to :poll_question,
             :foreign_key => :related_content_id

end
