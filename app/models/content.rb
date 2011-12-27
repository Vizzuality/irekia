class Content < ActiveRecord::Base
  belongs_to :author,
             :class_name => 'User',
             :foreign_key => :user_id,
             :select => 'id, name, lastname, locale, email, title_id, role_id, slug'

  has_many   :areas_contents,
             :class_name => "AreaContent"
  has_many   :areas,
             :through => :areas_contents

  has_many   :contents_users,
             :class_name => "ContentUser"
  has_many   :users,
             :through => :contents_users,
             :select => 'users.id, name, lastname, locale, email, title_id'
  has_many   :tagged_politicians,
             :through => :contents_users,
             :source => :user,
             :select => 'users.id, name, lastname, locale, email, title_id'

  has_many   :follows
  has_many   :participations
  has_many   :comments,
             :include => [{:author => :profile_picture}, :comment_data],
             :order => 'published_at asc'

  attr_protected :moderated, :rejected

  before_create :update_published_at
  before_save   :update_moderated_at
  before_save   :author_is_politician?

  accepts_nested_attributes_for :comments, :contents_users
  accepts_nested_attributes_for :areas_contents, :contents_users, :allow_destroy => true

  attr_accessor :parent
  attr_reader :tag, :image, :build_image

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
    includes(:areas, :author, :comments, :"#{name.underscore}_data").find(id)
  end

  def self.validate_all_not_moderated
    not_moderated.find_each do |content|
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

  def tag=(new_tag)
    return if new_tag.blank?

    tags_array = (tags || '').split(',')
    tags_array << new_tag
    self.tags = tags_array.join(',')
  end

  def all_tags_but(tag_to_remove)
    tags_array = (tags || '').split(',')
    tags_array.select{|t| t != tag_to_remove}.join(',')
  end

  def all_areas_but(area_to_remove)
    areas_contents.where('area_id <> ?', area_to_remove)
  end

  def last_contents(limit = 5)
    self.class.moderated.includes(:"#{self.class.name.underscore}_data", :comments).order('published_at desc').where('id <> ?', id).first(limit)
  end

  def participers(author)
    User.select(User.column_names.map{|c| "users.#{c}"})
        .group(User.column_names.map{|c| "users.#{c}"})
        .joins(:participations => :content)
        .where('contents.id = ? AND participations.user_id <> ?', id, author.id)
  end

  def commenters(author)
    participers(author).where('participations.type' => 'Comment')
  end

  def comments_count
    comments.moderated.reload.count || 0
  end

  def last_comments
    comments.moderated.reload.last(2)
  end

  def as_json(options = {})
    content_author = {
      :id            => author.id,
      :name          => author.name,
      :fullname      => author.fullname,
      :slug          => author.slug,
      :is_politician => author.politician?
    } if author.present?

    default = {
      :author          => content_author,
      :id              => id,
      :content_type    => type,
      :published_at    => published_at,
      :tags            => tags,
      :moderated       => moderated,
      :comments_count  => comments_count,
      :last_comments   => last_comments
    }

    default.merge(options)
  end

  def content_area
    if respond_to?(:target_area) && target_area.present?
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

  def publish

    return if author.blank?

    author.create_public_action(self)

    author.areas.each do |area|
      area.create_action(self)
      area.followers.each{|follower| follower.create_private_action(self)}
    end

    author.followers.each{|follower| follower.create_private_action(self)}

    tagged_politicians.each do |politician|
      politician.create_public_action(self)
      politician.create_private_action(self)
    end
  end

  def notify_of_new_participation(participation, force_notification_creation = false)
    publish

    areas.each{|area| area.create_action(participation)}

    users.each{|user| user.create_private_action(participation, force_notification_creation)}
    author.create_private_action(participation, force_notification_creation) if author.present?
    participers(author).each{|user| user.create_private_action(participation, force_notification_creation)}
  end

end
