class Photo < Content
  has_one :image

  delegate :title, :description, :original_url, :content_url, :to => :image

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

end
