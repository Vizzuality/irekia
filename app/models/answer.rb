class Answer < Content
  has_one :answer_data
  has_many :answer_opinions,
           :foreign_key => :content_id


  delegate :answer_text, :to => :answer_data

  accepts_nested_attributes_for :answer_opinions

  def to_html

  end
end
