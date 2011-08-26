class Event < Content
  has_one :event_data

  delegate :event_date, :title, :subtitle, :body, :to => :event_data

  before_save :update_areas_agenda

  accepts_nested_attributes_for :event_data

  def self.create_agenda_entry(attributes)
    event = self.new
    event.event_data = EventData.create attributes
    event.save!
    event
  end

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image
      },
      :published_at    => published_at,
      :event_date      => event_date,
      :title           => title,
      :subtitle        => subtitle,
      :body            => body,
      :comments_count  => comments_count
    }
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
