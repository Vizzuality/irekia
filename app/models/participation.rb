class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :author,
             :class_name => 'User',
             :foreign_key => :user_id,
             :select => 'id, role_id, title_id, name, lastname'
  belongs_to :content

  attr_protected :moderated, :rejected

  before_create :update_published_at
  before_save   :update_moderated_at
  before_save   :author_is_politician?
  after_save    :publish_participation
  after_save    :update_counter_cache
  after_destroy :update_counter_cache

  accepts_nested_attributes_for :user

  def self.find_or_initialize(params = nil)
    new(params)
  end

  def self.moderated
    where(:moderated => true)
  end

  def self.not_moderated
    where(:moderated => false)
  end

  def self.rejected
    where(:rejected => true)
  end

  def self.not_rejected
    where(:rejected => false)
  end

  def self.more_recent
    order('participations.published_at desc')
  end

  def self.validate_all_not_moderated
    self.not_moderated.find_each do |participation|
      participation.update_attribute('moderated', true)
    end
  end

  def self.moderation_time
    moderated.select('extract(epoch from avg(moderated_at - published_at)) as moderation_time').first.moderation_time.try(:to_f) || 0
  end

  def comments_count
    [].count
  end

  def update_published_at
    self.published_at = Time.now
  end
  private :update_published_at

  def update_moderated_at
    self.moderated_at = Time.now if moderated? && moderated_changed?
  end
  private :update_moderated_at

  def author_is_politician?
    self.moderated = true if author && author.politician?
  end
  private :author_is_politician?

  def as_json(options = {})
    default = {
      :author           => {
        :id               => user.id,
        :name             => user.name,
        :fullname         => user.fullname,
        :profile_image    => user.profile_image
      },
      :content_id       => content_id,
      :published_at     => published_at,
      :comments_count   => comments_count
    }

    default.merge(options || {})
  end

  def publish_participation
    return unless content.present? && self.moderated?

    content.areas.each do |area|
      area_action              = area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
      area_action.published_at = self.published_at
      area_action.message      = self.to_json
      area_action.save!
    end

    user_action              = user.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
    user_action.published_at = self.published_at
    user_action.message      = self.to_json
    user_action.save!

    user.followers.each do |follower|
      user_action              = follower.followings_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
      user_action.published_at = self.published_at
      user_action.message      = self.to_json
      user_action.save!
    end

  end
  private :publish_participation

  def update_counter_cache

  end
  private :update_counter_cache
end
