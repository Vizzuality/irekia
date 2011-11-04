class NewsData < ActiveRecord::Base
  belongs_to :news
  has_one :image
end
