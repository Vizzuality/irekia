class Video < Content
  has_one :video_data

  accepts_nested_attributes_for :video_data

  delegate :title, :description, :youtube_url, :vimeo_url, :thumbnail_url, :html, :to => :video_data, :allow_nil => true

  before_save :get_embed_html

  def as_json(options = {})
    super({
      :title         => title,
      :youtube_url   => youtube_url,
      :vimeo_url     => vimeo_url,
      :thumbnail_url => thumbnail_url
    })
  end

  def get_embed_html
    if youtube_url.present? || vimeo_url.present?
      oembed_json = JSON.parse(open("http://www.youtube.com/oembed?url=#{youtube_url || vimeo_url}&format=json&maxwidth=608").read) rescue nil
      if oembed_json.present?
        video_data.title         = oembed_json['title']
        video_data.thumbnail_url = oembed_json['thumbnail_url']
        video_data.html          = oembed_json['html']
      end
    end
  end
  private :get_embed_html
end
