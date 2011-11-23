class News < Content
  has_one :news_data,
          :dependent => :destroy

  delegate :title, :subtitle, :body, :source_url, :to => :news_data, :allow_nil => true

  def self.from_area(area)
    includes(:areas, :users => :areas).where('areas.id = ? OR areas_users.id = ?', area.id, area.id)
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
      :title           => title,
      :subtitle        => subtitle,
      :body            => body,
      :area            => area
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

  def publish
    return unless self.moderated?

    areas.each do |area|
      area_action              = area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
      area_action.published_at = self.published_at
      area_action.message      = self.to_json
      area_action.save!
    end

    users.each do |user|
      user_action              = user.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
      user_action.published_at = self.published_at
      user_action.message      = self.to_json
      user_action.save!

      user.areas.each do |area|
        area_action              = area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
        area_action.published_at = self.published_at
        area_action.message      = self.to_json
        area_action.save!

        area.followers.each do |follower|
          user_action              = follower.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
          user_action.published_at = self.published_at
          user_action.message      = self.to_json
          user_action.save!
        end
      end

      user.followers.each do |follower|
        user_action              = follower.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
        user_action.published_at = self.published_at
        user_action.message      = self.to_json
        user_action.save!
      end
    end
  end
  private :publish

end
