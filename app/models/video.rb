class Video < Content

  def update_counter_cache
    author.update_attribute("videos_count", author.actions.videos.count)
    author.followers.each{|user| user.update_attribute("private_videos_count", user.private_actions.videos.count)}
    author.areas.each { |area| area.update_attribute("videos_count", area.actions.videos.count) }
  end
  private :update_counter_cache

end
