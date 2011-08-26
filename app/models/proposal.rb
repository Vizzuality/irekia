class Proposal < Content
  has_one :proposal_data
  has_many :arguments,
           :foreign_key => :content_id,
           :dependent => :destroy

  scope :open, joins(:proposal_data).where('proposal_data.close' => false)
  scope :close, joins(:proposal_data).where('proposal_data.close' => true)

  accepts_nested_attributes_for :proposal_data, :arguments

  delegate :title, :body, :to => :proposal_data

  def percent_in_favor
    total_arguments = arguments.count
    return 0 if total_arguments.zero?
    (arguments.in_favor.count * 100 / arguments.count).round
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
        :profile_image => author.profile_image
      },
      :published_at    => published_at,
      :title           => title,
      :body            => body,
      :participation   => participation,
      :in_favor_count  => in_favor_count,
      :against_count   => against_count,
      :comments_count  => comments_count
    }
  end
end
