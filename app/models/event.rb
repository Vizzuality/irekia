class Event < Content
  has_one :event_data

  delegate :event_date, :title, :subtitle, :body, :location, :to => :event_data, :allow_nil => true

  accepts_nested_attributes_for :event_data

  def self.create_agenda_entry(attributes)
    event = self.new
    event.event_data = EventData.create attributes
    event.save!
    event
  end

  def self.from_area(area, start_date, end_date)
    Event.select('event_date, duration, title, subtitle, body')
         .includes(:event_data)
         .joins(:author => :areas)
         .moderated
         .where('areas.id = ? AND event_data.event_date >= ? AND event_data.event_date <= ?', area.id, start_date, end_date)
         .order('event_data.event_date asc')
  end

  def self.from_user(user, start_date, end_date)
    Event.select('event_date, duration, title, subtitle, body')
         .includes(:event_data)
         .joins(:author)
         .moderated
         .where('users.id = ? AND event_data.event_date >= ? AND event_data.event_date <= ?', user.id, start_date, end_date)
         .order('event_data.event_date asc')
  end

  def date
  end

  def time
    event_date.strftime('%H:%M')
  end

  def text
    title
  end

  def as_json(options = {})
    super({
      :event_date      => event_date,
      :title           => title,
      :subtitle        => subtitle,
      :body            => body,
      :location        => location,
      :latitude        => latitude,
      :longitude       => longitude
    })
  end

  def facebook_share_message
    title.truncate(140)
  end

  def twitter_share_message
    title.truncate(140)
  end

  def email_share_message
    title
  end

  def update_counter_cache
    return unless moderated?

    # areas.each { |area| area.update_attribute("events_count", area.events.moderated.count) }
    author.update_attribute("events_count", author.actions.events.count)
    author.followers.each{|user| user.update_attribute("private_events_count", user.private_actions.events.count)}
  end
  private :update_counter_cache

end
