class Proposal < Content
  include PgSearch

  has_one :proposal_data
  has_many :arguments,
           :foreign_key => :content_id,
           :dependent   => :destroy,
           :include     => :argument_data

  scope :open, joins(:proposal_data).where('proposal_data.close' => false)
  scope :close, joins(:proposal_data).where('proposal_data.close' => true)
  scope :from_politicians, joins(:users => :role).where('roles.name = ?', 'Politician')
  scope :from_citizens, joins(:users => :role).where('roles.name = ?', 'Citizen')

  pg_search_scope :search_existing_proposals, :associated_against => {
    :proposal_data => :title
  },
  :using => {
    :tsearch => {:prefix => true, :dictionary => 'spanish', :any_word => true}
  }

  accepts_nested_attributes_for :proposal_data, :arguments

  delegate :in_favor, :against, :participation, :title, :body, :target_user, :target_area, :to => :proposal_data

  def percent_in_favor
    return 0 if participation == 0
    (in_favor * 100 / participation).round
  end

  def percent_against
    100 - percent_in_favor
  end

  def moderated_participation
    arguments.moderated.count
  end

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :fullname      => author.fullname,
        :profile_image => author.profile_image
      },
      :id              => id,
      :published_at    => published_at,
      :title           => title,
      :body            => body,
      :participation   => participation,
      :in_favor_count  => in_favor,
      :against_count   => against,
      :comments_count  => comments_count,
      :last_comments   => last_comments,
      :percent_in_favor=> percent_in_favor,
      :percent_against => percent_against
    }
  end

  def update_statistics
    proposal_data.in_favor = arguments.in_favor.count
    proposal_data.against = arguments.against.count
    proposal_data.participation = arguments.count
    proposal_data.save!
  end

  def publish_content

    return unless self.moderated?

    User.where('id in (?)', target_area.user_ids).update_all('proposals_count = (proposals_count + 1)') if target_area

    super
  end
  private :publish_content
end
