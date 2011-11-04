class Event < Content
  has_one :event_data

  delegate :event_date, :title, :subtitle, :body, :location, :to => :event_data, :allow_nil => true

  before_save :update_areas_agenda

  accepts_nested_attributes_for :event_data

  def self.create_agenda_entry(attributes)
    event = self.new
    event.event_data = EventData.create attributes
    event.save!
    event
  end

  def date
  end

  def time
    event_date.strftime('%H:%M')
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

  private
  def update_areas_agenda
    self.users.each do |user|
      user.areas.each do |area|
        self.areas << area
      end
    end
  end
end
