class Content < ActiveRecord::Base
  belongs_to :author,
             :class_name => 'User',
             :foreign_key => :user_id,
             :select => 'id, name, lastname, locale, email, title_id, role_id'

  has_many   :areas_contents,
             :class_name => "AreaContent"
  has_many   :areas,
             :through => :areas_contents

  has_many   :contents_users,
             :class_name => "ContentUser"
  has_many   :users,
             :through => :contents_users,
             :select => 'users.id, name, lastname, locale, email'

  has_many   :follows
  has_many   :participations
  has_many   :comments,
             :include => [{:author => :profile_pictures}, :comment_data],
             :conditions => {:moderated => true},
             :order => 'published_at asc'

  attr_protected :moderated, :rejected

  before_create :update_published_at
  before_save   :update_moderated_at
  before_save   :author_is_politician?
  after_save    :publish_content
  after_save    :update_counter_cache
  after_destroy :update_counter_cache

  accepts_nested_attributes_for :comments, :areas_contents, :contents_users

  attr_accessor :location

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
    order('contents.published_at desc')
  end

  def self.more_polemic
    order('contents.comments_count desc')
  end

  def self.by_id(id)
    includes(:areas, :author, :comments, :"#{name.downcase}_data").find(id)
  end

  def self.validate_all_not_moderated
    self.not_moderated.find_each do |content|
      content.update_attribute('moderated', true)
    end
  end

  def self.moderation_time
    moderated.select('extract(epoch from avg(moderated_at - published_at)) as moderation_time').first.moderation_time.try(:to_f) || 0
  end

  def not_moderated?
    !moderated
  end

  def content_type
    type
  end

  def text

  end

  def last_contents(limit = 5)
    self.class.moderated.includes(:"#{self.class.name.downcase}_data", :comments).order('published_at desc').where('id <> ?', id).first(limit)
  end

  def commenters
    commenters_ids = User.select('DISTINCT(users.id)').joins(:comments).where('content_id = ?', id).map(&:id)
    User.where('id in (?)', commenters_ids)
  end

  def comments_count
    comments.size if comments
  end

  def last_comments
    comments.last(2)
  end

  def as_json(options = {})
    default = {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :fullname      => author.fullname,
        :profile_image => author.profile_image,
        :is_politician => author.politician?
      },
      :id              => id,
      :content_type    => type,
      :published_at    => published_at,
      :tags            => tags,
      :comments_count  => comments_count,
      :last_comments   => last_comments
    }

    default.merge(options)
  end

  def facebook_share_message

  end

  def twitter_share_message

  end

  def email_share_message

  end

  def content_area
    if defined?(:target_area) && target_area.present?
      target_area
    elsif areas.present?
      areas.first
    elsif author && author.areas.present?
      author.areas.first
    end
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
    self.moderated = true if author && author.politician? && not_moderated?
  end
  private :author_is_politician?

  def publish_content

    return unless self.moderated?

    user_action              = author.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
    user_action.published_at = self.published_at
    user_action.message      = self.to_json
    user_action.save!

    author.areas.each do |area|
      area_action              = area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
      area_action.published_at = self.published_at
      area_action.message      = self.to_json
      area_action.save!

      area.followers.each do |follower|
        user_action              = follower.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
        user_action.published_at = self.published_at
        user_action.message      = self.to_json
        user_action.save!
      end
    end

    author.followers.each do |follower|
      user_action              = follower.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
      user_action.published_at = self.published_at
      user_action.message      = self.to_json
      user_action.save!
    end

  end
  private :publish_content

  def update_counter_cache

  end
  private :update_counter_cache
end
