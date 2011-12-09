class Image < ActiveRecord::Base
  belongs_to :photo,
             :foreign_key => :photo_id
  belongs_to :user
  belongs_to :area
  belongs_to :news_data
  belongs_to :proposal_data
  belongs_to :event_data

  mount_uploader :image, ImageUploader

  def original_url
    image.original.url
  end

  def content_url
    image.content.url
  end

  def list_element_url
    image.list_element.url
  end

  def publish
    photo.publish         if photo.present?
    news_data.publish     if news_data.present?
    proposal_data.publish if proposal_data.present?
    event_data.publish    if event_data.present?
  end

end
