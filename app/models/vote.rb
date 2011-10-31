class Vote < Participation
  belongs_to :proposal,
             :foreign_key => :content_id

  has_one :vote_data

  before_save :set_as_moderated
  after_save :update_proposal

  delegate :in_favor, :against, :to => :vote_data
  delegate :title, :to => :proposal

  accepts_nested_attributes_for :vote_data

  def self.in_favor
    joins(:vote_data).where('vote_data.in_favor' => true)
  end

  def self.against
    joins(:vote_data).where('vote_data.in_favor' => false)
  end

  def as_json(options = {})
    {
      :author          => {
        :id            => user.id,
        :name          => user.name,
        :fullname      => user.fullname,
        :profile_image => user.profile_image
      },
      :published_at    => published_at,
      :title            => title,
      :in_favor        => in_favor,
      :against         => against,
      :comments_count  => comments_count
    }
  end

  def set_as_moderated
    self.moderated = true
  end
  private :set_as_moderated

  def update_proposal
    proposal.update_statistics
  end
  private :update_proposal

end
