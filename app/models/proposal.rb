class Proposal < Content
  has_many :arguments,
           :foreign_key => :related_content_id

  before_create :assign_opened_status

  scope :open, joins(:status).where('content_statuses.name' => 'open')

  def assign_opened_status
    self.status = ContentStatus.open_proposal if self.status.blank?
  end
  private :assign_opened_status
end