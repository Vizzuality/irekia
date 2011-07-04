class Content < ActiveRecord::Base
  belongs_to    :status,
                :class_name => 'ContentStatus',
                :foreign_key => :content_status_id

  has_many      :areas_contents,
                :class_name => "AreaContent"
  has_many      :areas,
                :through => :areas_contents

  has_many      :contents_authors,
                :class_name => "ContentAuthor"
  has_many      :contents_receivers,
                :class_name => "ContentReceiver"
  has_many      :contents_related_users,
                :class_name => "ContentRelatedUser"
  has_many      :authors,
                :through => :contents_authors,
                :source => :user
  has_many      :receivers,
                :through => :contents_receivers,
                :source => :user
  has_many      :related_users,
                :through => :contents_related_users,
                :source => :user

  has_many      :follows
  has_many      :participations

  before_create :update_published_at
  after_create  :publish_content

  def update_published_at
    self.published_at = DateTime.now
  end
  private :update_published_at

  def publish_content
    areas.each do |area|
      area_action = area.actions.new
      area_action.event_id   = self.id
      area_action.event_type = self.class.name.downcase
      area_action.message = self
      area_action.save!
    end
  end
  private :publish_content
end
