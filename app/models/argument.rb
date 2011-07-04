class Argument < Content
  belongs_to :proposal,
             :foreign_key => :related_content_id

  before_create :assign_default_status

  scope :in_favor, joins(:status).where('content_statuses.name' => 'in_favor')

  scope :against, joins(:status).where('content_statuses.name' => 'against')

  def assign_default_status
    self.status = ContentStatus.in_favor if self.status.blank?
  end
  private :assign_default_status
end
