class Role < ActiveRecord::Base
  translates :name

  has_many :users
end
