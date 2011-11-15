class Image < ActiveRecord::Base
  belongs_to :photo,
             :foreign_key => :photo_id
  belongs_to :user
  belongs_to :area
  belongs_to :news_data
  belongs_to :proposal_data
  belongs_to :event_data

  mount_uploader :image, ImageUploader

  attr_accessor :image_cache_name

  def image_cache_name=(name)
    image = ImageUploader.retrieve_from_cache!(name)
  end

  def original_url
    image.original.url
  end

  def content_url
    image.content.url
  end

  def list_element_url
    image.list_element.url
  end
end
