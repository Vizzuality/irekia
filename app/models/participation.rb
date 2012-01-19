class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :author,
             :class_name => 'User',
             :foreign_key => :user_id,
             :select => 'id, name, lastname, locale, email, title_id, role_id, slug'
  belongs_to :content

  attr_protected :moderated, :rejected
  attr_accessor :users_to_notificate

  before_save   :update_published_at
  before_save   :update_moderated_at
  before_save   :author_is_politician?

  accepts_nested_attributes_for :user

  alias :parent :content

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

  def not_moderated?
    !moderated
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
        :slug             => user.slug
      },
      :content_id       => content_id,
      :content => {
        :id   => content.try(:id),
        :slug => content.slug,
        :type => content.try(:type).try(:underscore),
        :text => content.try(:text)
      },
      :published_at     => published_at,
      :moderated        => moderated,
      :comments_count   => content.try(:comments_count)
    }

    default.merge(options || {})
  end

  def publish
    return unless content.present?

    @users_to_notificate = []

    user.create_public_action(self)

    user.areas.each do |area|
      area.create_action(self)
      @users_to_notificate += area.users
      @users_to_notificate += area.followers
    end

    @users_to_notificate += user.followers
  end

  def notify_content
    content.notify_of_new_participation(self)
  end

  def send_notifications
    return if user_id == id || content.user_id == user_id

    participation_json = to_json

    @users_to_notificate.uniq.each do |user|
      private_action = private_actions.find_or_create_by_event_id_and_event_type id, self.class.name
      private_action.published_at = published_at
      private_action.message      = participation_json
      private_action.author       = author if author.present?
      private_action.moderated    = moderated
      private_action.save!
    end

  end
end
