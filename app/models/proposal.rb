class Proposal < Content
  has_one :proposal_data
  has_many :arguments,
           :foreign_key => :content_id,
           :dependent => :destroy

  scope :open, joins(:proposal_data).where('proposal_data.close' => false)
  scope :close, joins(:proposal_data).where('proposal_data.close' => true)
  scope :from_politicians, joins(:users => :role).where('roles.name = ?', 'Politician')
  scope :from_citizens, joins(:users => :role).where('roles.name = ?', 'Citizen')

  accepts_nested_attributes_for :proposal_data, :arguments

  delegate :title, :body, :target_user, :target_area, :to => :proposal_data

  def percent_in_favor
    total_arguments = arguments.count
    return 0 if total_arguments.zero?
    (arguments.in_favor.count * 100 / total_arguments).round
  end

  def percent_against
    100 - percent_in_favor
  end

  def participation
    arguments.count
  end

  def in_favor_count
    arguments.in_favor.count
  end

  def against_count
    arguments.against.count
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
      :in_favor_count  => in_favor_count,
      :against_count   => against_count,
      :comments_count  => comments_count,
      :last_comments   => last_comments
    }
  end

  def publish_content

    return unless self.moderated?

    User.where('id in (?)', target_area.user_ids).update_all('proposals_count = (proposals_count + 1)') if target_area

    super
  end
  private :publish_content
end
