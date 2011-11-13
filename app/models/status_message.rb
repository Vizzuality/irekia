class StatusMessage < Content
  has_one :status_message_data

  delegate :message, :to => :status_message_data, :allow_nil => true

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

  def update_counter_cache
    author.update_attribute("statuses_count", author.actions.status_messages.count)
    author.followers.each{|user| user.update_attribute("private_statuses_count", user.private_actions.status_messages.count)}
    author.areas.each{|area| area.update_attribute("statuses_count", area.actions.status_messages.count)}
  end
  private :update_counter_cache

end
