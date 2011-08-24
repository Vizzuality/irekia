class Image < ActiveRecord::Base
  belongs_to :photo,
             :foreign_key => :photo_id
  belongs_to :user

  mount_uploader :image, ImageUploader

  def original_url
    image.original.url
  end

  def content_url
    image.content.url
  end
end
