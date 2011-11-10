module Admin::AdminHelper
  include ApplicationHelper

  def moderation_time
    hours = @moderation_time[:hours]
    minutes = @moderation_time[:minutes]
    hours = 120
    if hours > 100
      distance_of_time_in_words(Time.at(0), Time.at(hours.hours))
    else
    "#{hours}:#{minutes}h"
    end
  end

end
