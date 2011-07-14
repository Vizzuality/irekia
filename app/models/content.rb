class Content < ActiveRecord::Base

  has_many      :areas_contents,
                :class_name => "AreaContent"
  has_many      :areas,
                :through => :areas_contents

  has_many      :contents_users,
                :class_name => "ContentUser"
  has_many      :users,
                :through => :contents_users

  has_many      :follows
  has_many      :participations
  has_many      :comments

  before_create :update_published_at
  after_save  :publish_content

  accepts_nested_attributes_for :comments

  scope :moderated,     where(:moderated => true)
  scope :not_moderated, where(:moderated => false)

  def self.validate_all_not_moderated
    ActiveRecord::Base.connection.execute(<<-SQL
      UPDATE contents SET moderated = true WHERE moderated = false;
    SQL
    )
  end

  def update_published_at
    self.published_at = DateTime.now
  end
  private :update_published_at

  def publish_content
    return unless self.moderated?

    areas.each do |area|
      area_action = area.actions.new
      area_action.event_id   = self.id
      area_action.event_type = self.class.name.downcase
      area_action.message = self.to_html
      area_action.save!
    end
    users.each do |user|
      user_action = user.actions.new
      user_action.event_id   = self.id
      user_action.event_type = self.class.name.downcase
      user_action.message = self.to_html
      user_action.save!
    end
  end
  private :publish_content
end
