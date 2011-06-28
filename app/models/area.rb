class Area < ActiveRecord::Base
  has_many :users

  has_many :areas_contents, :class_name => "AreaContent"
  has_many :contents, :through => :areas_contents
  has_many :area_public_stream
end
