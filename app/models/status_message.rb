class StatusMessage < Content
  has_one :status_message_data

  delegate :message, :to => :status_message_data, :allow_nil => true

  accepts_nested_attributes_for :status_message_data

  def self.from_area(area)
    joins(:author => :areas).moderated.where('areas.id' => area.id)
  end

  def text
    message
  end

  def as_json(options = {})
    super({
      :message => message
    })
  end

end
