class Video < Content
  has_one :video_data

  accepts_nested_attributes_for :video_data

  delegate :title, :description, :youtube_url, :vimeo_url, :thumbnail_url, :html, :to => :video_data, :allow_nil => true

  def as_json(options = {})
    super({
      :title         => title,
      :youtube_url   => youtube_url,
      :vimeo_url     => vimeo_url,
      :thumbnail_url => thumbnail_url
    })
  end

end
