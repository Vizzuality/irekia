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
    read_attribute("title_#{I18n.locale}")
  end

  def title=(new_title)
    write_attribute("title_#{I18n.locale}", new_title)
  end

  def body
    read_attribute("title_#{I18n.locale}")
  end

  def body=(new_body)
    write_attribute("body_#{I18n.locale}", new_body)
  end
end
