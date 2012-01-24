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
    @to_update_public_streams  = (to_update_public_streams || [])
    @to_update_private_streams = (to_update_private_streams || [])

    @to_update_public_streams += areas
    @to_update_public_streams += areas.map(&:team).flatten
    @to_update_public_streams += users
    @to_update_public_streams += users.map(&:areas).flatten

    @to_update_private_streams += areas.map(&:followers).flatten
    @to_update_private_streams += users.map(&:followers).flatten
    @to_update_private_streams += users.map(&:areas).flatten.map(&:followers).flatten

    to_update_public_streams  = @to_update_public_streams
    to_update_private_streams = @to_update_private_streams

    super
  end

end
