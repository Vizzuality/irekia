class Content < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'

  has_many :areas_contents, :class_name => "AreaContent"
  has_many :areas, :through => :areas_contents
  has_many :contents_users, :class_name => "ContentUser"
  has_many :users, :through => :contents_users
  has_many :follows
  has_many :participations

  after_create :publish_content

  def publish_content
    areas.each do |area|
      area_action = area.actions.new

      area_action.event_id   = self.id
      area_action.event_type = self.class.name.downcase
      area_action.save!
    end
  end
  private :publish_content
end
