class Photo < Content
  has_one :image

  delegate :title, :description, :original_url, :content_url, :list_element_url, :to => :image, :allow_nil => true

  def as_json(options = {})
    super({
      :title            => title,
      :description      => description,
      :list_element_url => list_element_url,
      :content_url      => content_url
    })
  end

  def self.by_id(id)
    includes(:areas, :author, :comments, :image).find(id)
  end

  def self.from_user(user)
    moderated.where('user_id' => user.id)
  end

  def self.from_area(area)
    joins(:author => :areas).moderated.where('areas.id' => area.id)
  end

  def text
    title
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

  def update_counter_cache
    author.update_attribute("photos_count", author.actions.photos.count)
    author.followers.each{|user| user.update_attribute("private_photos_count", user.private_actions.photos.count)}
    author.areas.each{|area| area.update_attribute("photos_count", area.actions.photos.count)}
  end
  private :update_counter_cache

end
