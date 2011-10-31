class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :author,
             :class_name => 'User',
             :foreign_key => :user_id,
             :select => 'id, role_id, title_id, name, lastname'
  belongs_to :content

  attr_protected :moderated, :rejected

  before_create :update_published_at
  before_save :author_is_politician?
  after_save  :publish_participation

  accepts_nested_attributes_for :user

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

  def self.validate_all_not_moderated
    self.not_moderated.find_each do |participation|
      participation.update_attribute('moderated', true)
    end
  end

  def comments_count
    [].count
  end

  def update_published_at
    self.published_at = Time.now
  end
  private :update_published_at

  def author_is_politician?
    self.moderated = true if author && author.politician?
  end
  private :author_is_politician?

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
end
