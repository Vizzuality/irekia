class Photo < Content
  has_one :image

  delegate :title, :description, :original_url, :content_url, :to => :image, :allow_nil => true

  def as_json(options = {})
    super({
      :title           => title,
      :description     => description,
      :content_url     => content_url
    })
  end

  def self.by_id(id)
    includes(:areas, :users, :comments, :image).find(id)
  end

  def update_counter_cache
    areas.each { |area| area.update_attribute("photos_count", area.photos.moderated.count) }
    users.each { |user| user.update_attribute("photos_count", Photo.joins(:contents_users).where(:moderated => true, :'contents_users.user_id' => user.id)) }
  end
  private :update_counter_cache

end
