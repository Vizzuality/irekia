class StatusMessage < Content
  has_one :status_message_data

  delegate :message, :to => :status_message_data, :allow_nil => true

  def as_json(options = {})
    super({
      :message => message
    })
  end

  def update_counter_cache
    areas.each { |area| area.update_attribute("statuses_count", (area.status_messages.count + area.tweets.count)) }
    users.each { |user| user.update_attribute("statuses_count", (user.status_messages.moderated.count + user.tweets.moderated.count)) }
  end
  private :update_counter_cache

end
