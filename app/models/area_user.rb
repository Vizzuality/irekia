class AreaUser < ActiveRecord::Base
  belongs_to :area,
             :counter_cache => true
  belongs_to :user,
             :counter_cache => true,
             :select => 'users.id, users.name, users.lastname'
end
