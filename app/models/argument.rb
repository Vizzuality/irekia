class Argument < Participation
  belongs_to :proposal,
             :foreign_key => :content_id

  has_one :argument_data

  scope :in_favor, joins(:argument_data).where('argument_data.in_favor' => true)
  scope :against, joins(:argument_data).where('argument_data.in_favor' => false)

  after_initialize :create_argument_data

  def to_html

  end

  def create_argument_data
    self.argument_data = ArgumentData.new
    self.argument_data.in_favor = attributes[:in_favor] if attributes[:in_favor]
  end
  private :create_argument_data
end
