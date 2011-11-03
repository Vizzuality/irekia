class Argument < Participation
  belongs_to :proposal,
             :foreign_key => :content_id

  has_one :argument_data

  delegate :in_favor, :against, :reason, :to => :argument_data
  delegate :title, :to => :proposal

  accepts_nested_attributes_for :argument_data

  validates :reason, :presence => true

  def self.by_id(id)
    scoped.includes([{:user => :profile_pictures}, :argument_data, :proposal]).find(id)
  end

  def self.in_favor
    joins(:argument_data).where('argument_data.in_favor' => true)
  end

  def self.against
    joins(:argument_data).where('argument_data.in_favor' => false)
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
      :reason          => reason,
      :in_favor        => in_favor,
      :against         => against,
      :comments_count  => comments_count
    }
  end

end
