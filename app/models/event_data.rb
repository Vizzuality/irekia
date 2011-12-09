class EventData < ActiveRecord::Base
  has_one :image
  belongs_to :event

  def publish
    event.publish if event.present?
  end

end
