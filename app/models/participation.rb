class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :content

  before_create :update_published_at
  after_create  :publish_participation

  def update_published_at
    self.published_at = DateTime.now
  end
  private :update_published_at

  def publish_participation
    return if content.blank?

    content.areas.each do |area|
      area_action = area.actions.new
      area_action.event_id   = self.id
      area_action.event_type = self.class.name.downcase
      area_action.message = self.to_html
      area_action.save!
    end
  end
  private :publish_participation
end
