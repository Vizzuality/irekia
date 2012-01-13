class VideoData < ActiveRecord::Base
  belongs_to :video
  belongs_to :answer_data

  validate :a_valid_video_must_be_present

  def video_url
    youtube_url || vimeo_url
  end

  def video_url=(url)
    self.youtube_url = url
    self.vimeo_url   = url
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

  def a_valid_video_must_be_present
    errors.add(:video, :blank) and return if vimeo_url.blank? && youtube_url.blank?
    if vimeo_url.present?
      errors.add(:vimeo_url, :invalid) unless vimeo_url.match(/\A(http:\/\/)?(www.)?vimeo.com/)
    elsif youtube_url.present?
      errors.add(:youtube_url, :invalid) unless youtube_url.match(/\A(http:\/\/)?(www.)?youtube.com/)
    end
  end
end
