class Proposal < Content
  include PgSearch

  has_one :proposal_data,
          :select => 'id, proposal_id, area_id, title, body, close, participation, in_favor, against'
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

  delegate :in_favor, :against, :participation, :title, :body, :target_area, :image, :build_image, :to => :proposal_data, :allow_nil => true

  def self.by_id(id)
    scoped.includes([{:author => :profile_picture}, :proposal_data, { :comments => [:author, :comment_data] }]).find(id)
  end

  def self.open
    joins(:proposal_data).where('proposal_data.close' => false)
  end

  def self.close
    joins(:proposal_data).where('proposal_data.close' => true)
  end

  def self.from_politicians
    joins(:author => :role)
    .moderated
    .where('roles.name' => 'Politician')
  end

  def self.from_politician_areas(politician)
    joins(:author => {:areas => :team})
    .moderated
    .where('teams_areas.id = ?', politician.id)
  end

  def self.from_citizens
    joins(:author => :role)
    .moderated
    .where('roles.name = ?', 'Citizen')
  end

  def self.from_area(area, author)
    query = joins(:proposal_data => :target_area)
    .where('areas.id = ?', area.id)
    if author.present?
      query.where('contents.moderated = ? OR (contents.moderated = ? AND contents.user_id = ?)', true, false, author.id)
    else
      query.moderated
    end
  end

  def self.user_is_author_or_participer(user, show_not_moderated = nil)
    query = select('distinct contents.*')
    .includes(:author, :votes => :author, :arguments => :author)
    if show_not_moderated
      query
      .where('users.id = ? OR (contents.moderated = ? AND authors_participations.id = ?) OR (contents.moderated = ? AND authors_participations_2.id = ?)', user.id, true, user.id, true, user.id)
    else
      query
      .moderated
      .where('users.id = ? OR authors_participations.id = ? OR authors_participations_2.id = ?', *([user.id] * 3))
    end
  end

  def self.from_citizen(user)
    joins(:author).moderated.where('users.id' => user.id)
  end

  def self.approved_by_majority
    joins(:proposal_data).where('proposal_data.in_favor > proposal_data.against')
  end

  def text
    title
  end

  def has_image?
    image.present? && image.content_url.present?
  end

  def percent_in_favor
    return 100 if participation.blank?
    return 100 if participation == 0
    (in_favor * 100 / participation).round || 100
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
      :percent_against  => percent_against,
      :target_area      => {
        :id   => target_area.try(:id),
        :name => target_area.try(:name)
      }
    })
  end

  def update_statistics
    return unless proposal_data && votes

    proposal_data.in_favor      = votes.in_favor.count
    proposal_data.against       = votes.against.count
    proposal_data.participation = votes.count
    proposal_data.save!
  end

  def publish
    super

    author.create_public_action(self)

    if target_area
      target_area.create_action(self)
      target_area.followers.each{|follower| follower.create_private_action(self)}
      target_area.team.each do |politician|
        politician.create_private_action(self)
      end
    end

  end

end
