class EventData < ActiveRecord::Base
  has_one :image
  belongs_to :event

end
