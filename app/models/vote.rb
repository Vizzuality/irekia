class Vote < Participation
  belongs_to :proposal,
             :foreign_key => :content_id

  has_one :vote_data

  before_save :set_as_moderated
  after_save :update_proposal

  delegate :in_favor, :against, :to => :vote_data, :allow_nil => true
  delegate :title, :to => :proposal, :allow_nil => true

  accepts_nested_attributes_for :vote_data

  def self.find_or_initialize(params = nil)
    new_vote = new(params)
    vote = User.find(params[:user_id]).his_opinion(Content.find(params[:content_id])).first if params.present?
    if vote.present?
      vote.vote_data.in_favor = params[:vote_data_attributes][:in_favor]
    end
    vote || new_vote
  end

  def self.by_id(id)
    scoped.includes([{:user => :profile_pictures}, :vote_data]).find(id)
  end

  def self.from_area(area)
    joins(:author => :areas).moderated.where('areas.id' => area.id)
  end

  def self.in_favor
    joins(:vote_data).where('vote_data.in_favor' => true)
  end

  def self.against
    joins(:vote_data).where('vote_data.in_favor' => false)
  end

  def as_json(options = {})
    super({
      :title            => title,
      :in_favor        => in_favor,
      :against         => against
    })
  end

  def set_as_moderated
    self.moderated = true
  end
  private :set_as_moderated

  def update_proposal
    proposal.update_statistics if moderated?
  end
  private :update_proposal

  def update_counter_cache
    return unless moderated?

    author.update_attribute('votes_count', author.actions.votes.count)
    author.followers.each{|user| user.update_attribute("private_votes_count", user.private_actions.votes.count)}
    author.areas.each{|area| area.update_attribute('votes_count', area.actions.votes.count)}
  end
  private :update_counter_cache
end
