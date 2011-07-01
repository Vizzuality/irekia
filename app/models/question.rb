class Question < Content
  has_many :answers

  scope :answered, joins(:answers)
end