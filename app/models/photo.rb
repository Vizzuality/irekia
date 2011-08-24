class Photo < Content
  has_one :image

  delegate :title, :description, :original_url, :content_url, :to => :image

  def to_html

  end
end