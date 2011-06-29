class Sex < ActiveRecord::Base
  translates :name

  has_many :users
end
