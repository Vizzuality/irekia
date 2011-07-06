class Proposal < Content
  has_one :proposal_data
  has_many :arguments,
           :foreign_key => :content_id

  scope :open, joins(:proposal_data).where('proposal_data.close' => false)
  scope :close, joins(:proposal_data).where('proposal_data.close' => true)

  delegate :proposal_text, :to => :proposal_data

  def to_html

  end

end