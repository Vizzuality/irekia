class NewsData < ActiveRecord::Base
  belongs_to :news
  has_one :image

  accepts_nested_attributes_for :image, :allow_destroy => true

  def title
    read_attribute("title_#{I18n.locale}")
  end

  def subtitle
    read_attribute("subtitle_#{I18n.locale}")
  end

  def body
    read_attribute("body_#{I18n.locale}")
  end

  def source_url
    read_attribute("source_url_#{I18n.locale}")
  end

  def title=(value)
    write_attribute("title_#{I18n.locale}", value)
  end

  def subtitle=(value)
    write_attribute("subtitle_#{I18n.locale}", value)
  end

  def body=(value)
    write_attribute("body_#{I18n.locale}", value)
  end

  def source_url=(value)
    write_attribute("source_url_#{I18n.locale}", value)
  end

end
