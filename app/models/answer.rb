class Answer < Content
  belongs_to :question,
             :foreign_key => :related_content_id
end
