class Proposal < Content
  has_one :proposal_data
  has_many :arguments,
           :foreign_key => :content_id

  scope :open, joins(:proposal_data).where('proposal_data.close' => false)
  scope :close, joins(:proposal_data).where('proposal_data.close' => true)

  accepts_nested_attributes_for :proposal_data, :arguments

  delegate :title, :body, :to => :proposal_data

  def percent_in_favor
    total_arguments = arguments.count
    return 0 if total_arguments.zero?
    (arguments.in_favor.count * 100 / arguments.count).round
  end

  def to_html

  end

end
