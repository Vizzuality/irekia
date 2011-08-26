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

  reverse_geocoded_by :latitude, :longitude

  # after_validation :reverse_geocode

  def self.validate_all_not_moderated
    self.not_moderated.find_each do |content|
      content.update_attribute('moderated', true)
    end
  end

  def latitude
    the_geom.try(:latitude)
  end

  def longitude
    the_geom.try(:longitude)
  end

  def author
    users.first if users.present?
  end

  def location
    reverse_geocode if Rails.env.staging? || Rails.env.production?
  end

  def comments_count
    comments.count if comments
  end

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image
      },
      :published_at    => published_at,
      :comments => comments.count
    }
  end

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
      },
      :published_at    => published_at,
      :comments => comments.count
    }
  end

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image_thumb_url
      },
      :published_at    => published_at,
      :comments => comments.count
    }
  end

  def update_published_at
    self.published_at = Time.now
  end
  private :update_published_at

  def publish_content

    return unless self.moderated?

    areas.each do |area|
      area_action              = area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
      area_action.published_at = self.published_at
      area_action.message      = self.to_json
      area_action.save!
    end
    users.each do |user|
      user_action              = user.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
      user_action.published_at = self.published_at
      user_action.message      = self.to_json
      user_action.save!
    end
  end
  private :publish_content
end
