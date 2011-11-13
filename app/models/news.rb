class News < Content
  has_one :news_data

  delegate :title, :subtitle, :body, :to => :news_data, :allow_nil => true

  def self.from_area(area)
    includes(:areas, :users => :areas).where('areas.id = ? OR areas_users.id = ?', area.id, area.id)
  end

  def text
    title
  end

  def as_json(options = {})
    super({
      :title           => title,
      :subtitle        => subtitle,
      :body            => body
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

  def publish_content
    return unless self.moderated?

    areas.each do |area|
      area_action              = area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
      area_action.published_at = self.published_at
      area_action.message      = self.to_json
      area_action.save!
    end

    users.each do |user|
      user_action              = user.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
      user_action.published_at = self.published_at
      user_action.message      = self.to_json
      user_action.save!

      user.areas.each do |area|
        area_action              = area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
        area_action.published_at = self.published_at
        area_action.message      = self.to_json
        area_action.save!

        area.followers.each do |follower|
          user_action              = follower.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
          user_action.published_at = self.published_at
          user_action.message      = self.to_json
          user_action.save!
        end
      end

      user.followers.each do |follower|
        user_action              = follower.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
        user_action.published_at = self.published_at
        user_action.message      = self.to_json
        user_action.save!
      end
    end
  end
  private :publish_content

  def update_counter_cache
    return unless moderated?

    areas.each{ |area| area.update_attribute("news_count", area.actions.news.count) }
    users.each do |user|
      user.update_attribute("news_count", user.actions.news.count)
      user.followers.each{|user| user.update_attribute("private_news_count", user.private_actions.news.count)}
      user.areas.each{ |area| area.update_attribute("news_count", area.actions.news.count) }
    end
  end
  private :update_counter_cache

end
