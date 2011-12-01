class NewsData < ActiveRecord::Base
  belongs_to :news
  has_one :image

  accepts_nested_attributes_for :image, :allow_destroy => true
end
