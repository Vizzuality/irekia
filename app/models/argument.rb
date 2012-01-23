class Argument < Participation
  belongs_to :proposal,
             :foreign_key => :content_id

  has_one :argument_data

  delegate :in_favor, :against, :reason, :to => :argument_data, :allow_nil => true
  delegate :title, :percent_in_favor, :percent_against, :percentage, :participation, :to => :proposal, :allow_nil => true

  accepts_nested_attributes_for :argument_data

  validates :reason, :presence => true

  def self.by_id(id)
    scoped.includes([{:user => :profile_picture}, :argument_data, :proposal]).find(id)
  end

  def self.from_area(area)
    joins(:author => :areas).moderated.where('areas.id' => area.id)
  end

  def self.in_favor
    joins(:argument_data).where('argument_data.in_favor' => true)
  end

  def self.against
    joins(:argument_data).where('argument_data.in_favor' => false)
  end

  def parent
    proposal
  end

  def as_json(options = {})
    super({
      :title            => title,
      :percent_in_favor => percent_in_favor,
      :percent_against  => percent_against,
      :percentage       => percentage,
      :participation    => participation,
      :reason           => reason,
      :in_favor         => in_favor,
      :against          => against
    })
  end

  def publish

    return if self.author.blank?

    @to_update_private_streams = (to_update_private_streams || [])

    @to_update_private_streams += content.participers(author).where('participations.type' => 'Argument')
    @to_update_private_streams += proposal.target_area.team.reject{|politician| politician == author}

    super
  end

end
