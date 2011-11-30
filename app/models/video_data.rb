class VideoData < ActiveRecord::Base
  belongs_to :video
  belongs_to :answer_data

  before_save :get_embed_html

  def get_embed_html
    if youtube_url.present? || vimeo_url.present?
      if youtube_url.present?
        oembed_json = JSON.parse(open("http://www.youtube.com/oembed?url=#{vimeo_url}&format=json&maxwidth=608").read) rescue nil
      elsif vimeo_url.present?
        oembed_json = JSON.parse(open("http://vimeo.com/api/oembed.json?url=#{vimeo_url}&maxwidth=608").read) rescue nil
      end

      if oembed_json.present?
        self.title         = oembed_json['title']
        self.thumbnail_url = oembed_json['thumbnail_url']
        self.html          = oembed_json['html']
      end
    end
  end
  private :get_embed_html
end
