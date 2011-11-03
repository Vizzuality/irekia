class Proposal < Content
  include PgSearch

  has_one :proposal_data,
          :select => 'id, proposal_id, area_id, user_id, title, body, close, participation, in_favor, against'
  has_many :votes,
           :foreign_key => :content_id,
           :dependent   => :destroy,
           :include     => :vote_data
  has_many :arguments,
           :foreign_key => :content_id,
           :dependent   => :destroy,
           :include     => :argument_data,
           :order       => 'published_at'

  pg_search_scope :search_existing_proposals,
                  :associated_against => {
                    :proposal_data => :title
                  },
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }

  accepts_nested_attributes_for :proposal_data, :arguments, :votes

  delegate :in_favor, :against, :participation, :title, :body, :target_user, :target_area, :to => :proposal_data

  def self.by_id(id)
    scoped.includes([{:users => :profile_pictures}, :proposal_data, { :comments => [:author, :comment_data] }]).find(id)
  end

  def self.open
    joins(:proposal_data).where('proposal_data.close' => false)
  end

  def self.close
    joins(:proposal_data).where('proposal_data.close' => true)
  end

  def self.from_politicians
    joins(:users => :role).where('roles.name = ?', 'Politician')
  end

  def self.from_citizens
    joins(:users => :role).where('roles.name = ?', 'Citizen')
  end

  def self.approved_by_majority
    joins(:proposal_data).where('proposal_data.in_favor > proposal_data.against')
  end

  def percent_in_favor
    return 0 if participation.blank?
    return 0 if participation == 0
    (in_favor * 100 / participation).round || 0
  end

  def percent_against
    100 - percent_in_favor
  end

  def percentage
    [percent_in_favor, percent_against].sort.last
  end

  def as_json(options = {})
    super({
      :title            => title,
      :participation    => participation,
      :in_favor         => in_favor,
      :against          => against,
      :percentage       => percentage,
      :percent_in_favor => percent_in_favor,
      :percent_against  => percent_against
    })
  end

  def update_statistics
    proposal_data.in_favor      = votes.in_favor.count
    proposal_data.against       = votes.against.count
    proposal_data.participation = votes.count
    proposal_data.save!
  end

  def publish_content

    return unless self.moderated?

    User.where('id in (?)', target_area.user_ids).update_all('proposals_count = (proposals_count + 1)') if target_area

    super
  end
  private :publish_content
end
