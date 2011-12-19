class News < Content
  has_one :news_data,
          :dependent => :destroy

  delegate :title, :subtitle, :body, :source_url, :image, :build_image, :to => :news_data, :allow_nil => true
  accepts_nested_attributes_for :news_data

  def self.from_area(area)
    includes(:areas, :users => :areas).where('areas.id = ? OR areas_users.id = ?', area.id, area.id)
  end

  def text
    title
  end

  def as_json(options = {})
    area = {
      :id            => areas.first.id,
      :name          => areas.first.name,
      :thumbnail     => areas.first.thumbnail
    } if areas.present?

    super({
      :title           => title,
      :subtitle        => subtitle,
      :body            => body,
      :area            => area
    })
  end

  def facebook_share_message
    title.truncate(140)
  end

  def twitter_share_message
    title.truncate(140)
  end

  def email_share_message
    title
  end

  def publish
    super

    areas.each{|area| area.create_action(self)}

    users.each do |user|
      user.create_public_action(self)

      user.areas.each do |area|
        area.create_action(self)

        area.followers.each{|follower| follower.create_private_action(self)}
      end

      user.followers.each{|follower| follower.create_private_action(self)}
    end
  end

end
