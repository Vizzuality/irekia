class Event < Content
  has_one :event_data

  delegate :event_date, :duration, :title, :subtitle, :body, :image, :build_image, :to => :event_data, :allow_nil => true

  accepts_nested_attributes_for :event_data

  def self.create_agenda_entry(attributes)
    event = self.new
    event.event_data = EventData.create attributes
    event.save!
    event
  end

  def self.general_agenda(filters)
    start_date, end_date = calendar_bounds(3, filters)

    events = Event.select('event_date, duration, title, subtitle, body')
         .includes(:event_data)
         .moderated
         .where('event_data.event_date >= ? AND event_data.event_date <= ?', start_date, end_date)
         .order('event_data.event_date asc')

    events_to_agenda(events, start_date, end_date)
  end

  def self.from_area(area, weeks, filters)
    start_date, end_date = calendar_bounds(weeks, filters)

    events = Event.select('event_date, duration, title, subtitle, body')
         .includes(:event_data)
         .joins(:author => :areas)
         .moderated
         .where('areas.id = ? AND event_data.event_date >= ? AND event_data.event_date <= ?', area.id, start_date, end_date)
         .order('event_data.event_date asc')

    events_to_agenda(events, start_date, end_date)
  end

  def self.from_user(user, weeks, filters)
    start_date, end_date = calendar_bounds(weeks, filters)

    events = Event.select('event_date, duration, title, subtitle, body')
         .includes(:event_data)
         .joins(:author)
         .moderated
         .where('users.id = ? AND event_data.event_date >= ? AND event_data.event_date <= ?', user.id, start_date, end_date)
         .order('event_data.event_date asc')

    events_to_agenda(events, start_date, end_date)
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
    area = {
      :id            => areas.first.id,
      :name          => areas.first.name,
      :thumbnail     => areas.first.thumbnail
    } if areas.present?

    super({
      :event_date      => event_date,
      :duration        => duration,
      :title           => title,
      :subtitle        => subtitle,
      :body            => body,
      :location        => location,
      :latitude        => latitude,
      :longitude       => longitude,
      :area            => area
    })
  end

  def self.calendar_bounds(weeks, filters)
    calendar_date = Date.current
    if filters[:next_month].present?
      calendar_date = Date.current.advance(:months => filters[:next_month].to_i)
    end

    beginning_of_calendar = calendar_date.beginning_of_week
    end_of_calendar = calendar_date.advance(:weeks => weeks).end_of_week
    return beginning_of_calendar, end_of_calendar
  end

  def self.events_to_agenda(events, beginning_of_week, end_of_week)
    agenda      = events.group_by{|e| e.event_date.day }
    days        = beginning_of_week..end_of_week
    agenda_json = JSON.generate(events.map{|event| {
      :title      => event.title,
      :date       => I18n.localize(event.event_date, :format => '%d, %B de %Y'),
      :when       => event.event_date.strftime('%H:%M'),
      :where      => event.try(:location),
      :lat        => event.latitude,
      :lon        => event.longitude,
      :event_id   => event.id,
      :area_id    => event.try(:content_area).try(:id)
    }}.group_by{|event| [event[:lat], event[:lon]]}.values).html_safe

    return agenda, days, agenda_json
  end

  def self.to_calendar(agenda)
    calendar = RiCal.Calendar do |cal|
      agenda.values.flatten.each do |event_data|
        cal.event do |event|
          event.summary = event_data.title
          event.description = event_data.body
          event.dtstart = event_data.event_date
          event.dtend = event_data.event_date + (event_data.duration || 0)
          event.location = event_data.location
          event_data.users.each do |politician|
            event.add_attendee "#{politician.fullname}<#{politician.email}>"
          end
        end
      end
    end

    calendar.to_s if calendar.present?
  end

  def to_calendar
    self.class.to_calendar(event_date.day => self)
  end

  def publish
    @to_update_public_streams  = (to_update_public_streams || [])
    @to_update_private_streams = (to_update_private_streams || [])

    @to_update_public_streams += areas
    @to_update_public_streams += users

    @to_update_private_streams += areas.map(&:team).flatten
    @to_update_private_streams += users.map(&:areas).flatten
    @to_update_private_streams += areas.map(&:followers).flatten
    @to_update_private_streams += users.map(&:followers).flatten

    to_update_public_streams  = @to_update_public_streams
    to_update_private_streams = @to_update_private_streams

    super
  end
end
