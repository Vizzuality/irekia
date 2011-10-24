class Content < ActiveRecord::Base

  has_many      :areas_contents,
                :class_name => "AreaContent"
  has_many      :areas,
                :through => :areas_contents

  has_many      :contents_users,
                :class_name => "ContentUser"
  has_many      :users,
                :through => :contents_users,
                :select => 'name, lastname'

  has_many      :follows
  has_many      :participations
  has_many      :comments,
                :include => [{:author => :profile_pictures}, :comment_data],
                :conditions => {:moderated => true}

  attr_protected :moderated

  before_create :update_published_at
  after_save :author_is_politician?
  after_save  :publish_content
  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  accepts_nested_attributes_for :comments, :contents_users

  scope :moderated,     where(:moderated => true)
  scope :not_moderated, where(:moderated => false)
  scope :more_recent, order('contents.published_at desc')
  scope :more_polemic, joins(<<-SQL
    LEFT JOIN participations ON
    participations.content_id = contents.id AND
    participations.type = 'Comment'
  SQL
  ).select('count(participations.id) as comments_count').group(Content.column_names.map{|c| "contents.#{c}"}).order('comments_count desc')

  attr_accessor :location

  def not_moderated?
    !moderated
  end

  def self.by_id(id)
    includes(:areas, :users, :comments, :"#{name.downcase}_data").find(id)
  end

  def self.validate_all_not_moderated
    self.not_moderated.find_each do |content|
      content.update_attribute('moderated', true)
    end
  end

  def last_contents
    self.class.moderated.includes(:"#{self.class.name.downcase}_data", :comments).order('published_at desc').where('id <> ?', id).first(5)
  end

  def commenters
    commenters_ids = User.select('DISTINCT(users.id)').includes().joins(:comments).where('content_id = ?', id).map(&:id)
    User.where('id in (?)', commenters_ids)
  end

  def author
    users.first if users.present?
  end

  def comments_count
    comments.size if comments
  end

  def last_comments
    comments.last(2)
  end

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :fullname          => author.fullname,
        :profile_image => author.profile_image
      },
      :published_at    => published_at,
      :comments => comments_count
    }
  end

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :fullname      => author.fullname,
        :profile_image => author.profile_image
      },
      :published_at    => published_at,
      :comments => comments_count
    }
  end

  def update_published_at
    self.published_at = Time.now
  end
  private :update_published_at

  def author_is_politician?
    update_attribute('moderated', true) if author.politician? && not_moderated?
  end
  private :author_is_politician?

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

      user.followers.each do |follower|
        user_action              = follower.followings_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
        user_action.published_at = self.published_at
        user_action.message      = self.to_json
        user_action.save!
      end

    end
  end
  private :publish_content

  def increment_counter_cache
    areas.each { |area| Area.increment_counter("#{self.class.name.downcase.pluralize}_count", area.id) }
    users.each { |user| User.increment_counter("#{self.class.name.downcase.pluralize}_count", user.id) }
  end
  private :increment_counter_cache

  def decrement_counter_cache
    areas.each { |area| Area.decrement_counter("#{self.class.name.downcase.pluralize}_count", area.id) }
    users.each { |user| User.decrement_counter("#{self.class.name.downcase.pluralize}_count", user.id) }
  end
  private :decrement_counter_cache
end
