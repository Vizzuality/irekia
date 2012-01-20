class NewsData < ActiveRecord::Base
  belongs_to :news
  has_one :image

  accepts_nested_attributes_for :image, :allow_destroy => true

  def title
    read_attribute("title_#{I18n.locale}") || (I18n.available_locales - [I18n.locale]).map{|lang| read_attribute("title_#{lang}")}.compact.first || read_attribute('title') || ''
  end

  def title=(new_title)
    write_attribute("title_#{I18n.locale}", new_title)
  end

  def body
    read_attribute("body_#{I18n.locale}") || (I18n.available_locales - [I18n.locale]).map{|lang| read_attribute("body_#{lang}")}.compact.first || read_attribute('body') || ''
  end

  def body=(new_body)
    write_attribute("body_#{I18n.locale}", new_body)
  end
end
