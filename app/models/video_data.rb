class VideoData < ActiveRecord::Base
  belongs_to :video
  belongs_to :answer_data

  def youtube_url=(url)
    write_attribute(:youtube_url, url)
    if url.present?
      oembed_json = JSON.parse(open("http://www.youtube.com/oembed?url=#{vimeo_url}&format=json&maxwidth=608").read) rescue nil

      store_oembed(oembed_json)
    end
  end

  def vimeo_url=(url)
    write_attribute(:vimeo_url, url)
    if url.present?
      oembed_json = JSON.parse(open("http://vimeo.com/api/oembed.json?url=#{vimeo_url}&maxwidth=608").read) rescue nil

      store_oembed(oembed_json)
    end
  end

  def store_oembed(oembed_json)
    if oembed_json.present?
      self.title         = oembed_json['title']
      self.thumbnail_url = oembed_json['thumbnail_url']
      self.html          = oembed_json['html']
    end
  end
  private :store_oembed
end
