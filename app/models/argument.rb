class Argument < Participation
  belongs_to :proposal,
             :foreign_key => :content_id

  has_one :argument_data

  scope :in_favor, joins(:argument_data).where('argument_data.in_favor' => true)
  scope :against, joins(:argument_data).where('argument_data.in_favor' => false)
  scope :with_reason, joins(:argument_data).where('argument_data.reason IS NOT NULL')

  delegate :reason, :to => :argument_data

  accepts_nested_attributes_for :argument_data

  def to_html

  end
end
