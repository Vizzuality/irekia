class News < Content
  has_one :news_data,
          :dependent => :destroy

  delegate :title, :title_es, :title_eu, :title_en, :subtitle, :body, :body_es, :body_eu, :body_en, :source_url, :iframe_url, :image, :build_image, :to => :news_data, :allow_nil => true
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
      :title_es        => title_es,
      :title_eu        => title_eu,
      :title_en        => title_en,
      :subtitle        => subtitle,
      :body_es         => body_es,
      :body_eu         => body_eu,
      :body_en         => body_en,
      :area            => area
    })
  end

  def publish
    super

    areas.each{|area| area.create_action(self)}

    users.each do |user|
      user.create_public_action(self)

      user.areas.each do |area|
        area.create_action(self)

        @users_to_notificate += area.followers
      end

      @users_to_notificate += user.followers
      user.followers.notify_all(self)
    end
  end

end
