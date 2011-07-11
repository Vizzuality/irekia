class Image < ActiveRecord::Base
  belongs_to :image_gallery
  belongs_to :user

  mount_uploader :image, ImageUploader
end
