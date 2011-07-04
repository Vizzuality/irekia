class Argument < Content
  belongs_to :proposal,
             :foreign_key => :related_content_id

  before_create :assign_default_status

  def assign_default_status
    self.status = ContentStatus.in_favor if self.status.blank?
  end
  private :assign_default_status
end
