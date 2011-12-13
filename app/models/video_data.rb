class VideoData < ActiveRecord::Base
  belongs_to :video
  belongs_to :answer_data

  attr_reader :video_url

  def video_url=(url)
    if url.match(/http:\/\/www.youtube.com/)
      self.youtube_url = url
    elsif url.match(/http:\/\/vimeo.com/)
      self.vimeo_url = url
    end
  end

  def youtube_url=(url)
    write_attribute(:youtube_url, url)
    if url.present?
      oembed_json = JSON.parse(open("http://www.youtube.com/oembed?url=#{url}&format=json&maxwidth=608").read) rescue nil

      store_oembed(oembed_json)
    end
  end

  def vimeo_url=(url)
    write_attribute(:vimeo_url, url)
    if url.present?
      oembed_json = JSON.parse(open("http://vimeo.com/api/oembed.json?url=#{url}&maxwidth=608").read) rescue nil

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
