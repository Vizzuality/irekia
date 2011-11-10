class Video < Content

  def update_counter_cache
    areas.each { |area| area.update_attribute("videos_count", area.videos.moderated.count) }
    users.each { |user| user.update_attribute("videos_count", user.videos.moderated.count) }
  end
  private :update_counter_cache

end
