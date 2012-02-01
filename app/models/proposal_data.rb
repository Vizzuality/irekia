class ProposalData < ActiveRecord::Base
  has_one :image

  belongs_to :proposal,
             :foreign_key => :proposal_id

  belongs_to :target_area,
             :class_name => 'Area',
             :foreign_key => :area_id

  accepts_nested_attributes_for :image, :allow_destroy => true

  delegate :content_url, :to => :image

  def title
    current_locale_title = read_attribute("title_#{I18n.locale}")
    alt_locale_title = (I18n.available_locales - [I18n.locale]).map{|lang| read_attribute("title_#{lang}")}.select{|v| v.present?}.first
    return current_locale_title if current_locale_title.present?
    return alt_locale_title if alt_locale_title.present?
    ''
  rescue
    ''
  end

  def title=(new_title)
    write_attribute("title_#{I18n.locale}", new_title)
  end

  def body
    current_locale_body = read_attribute("body_#{I18n.locale}")
    alt_locale_body = (I18n.available_locales - [I18n.locale]).map{|lang| read_attribute("body_#{lang}")}.select{|v| v.present?}.first
    return current_locale_body if current_locale_body.present?
    return alt_locale_body if alt_locale_body.present?
    ''
  rescue
    ''
  end

  def body=(new_body)
    write_attribute("body_#{I18n.locale}", new_body)
  end
end
