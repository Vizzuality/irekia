class Area < ActiveRecord::Base
  include PgSearch

  has_many :areas_users,
           :class_name => 'AreaUser'
  has_many :users,
           :through => :areas_users
  has_many :areas_contents,
           :class_name => 'AreaContent'
  has_many :contents,
           :through => :areas_contents
  has_many :questions,
           :through => :areas_contents
  has_many :proposals,
           :through => :areas_contents
  has_many :news,
           :through => :areas_contents
  has_many :videos,
           :through => :areas_contents
  has_many :photos,
           :through => :areas_contents
  has_many :events,
           :through => :areas_contents,
           :include => :event_data,
           :order => 'event_data.event_date asc'
  has_many :actions,
           :class_name => 'AreaPublicStream'
  has_many :follows,
           :as => :follow_item
  has_many :followers,
           :through => :follows,
           :source => :user

  accepts_nested_attributes_for :questions
  accepts_nested_attributes_for :follows, :allow_destroy => true

  pg_search_scope :search_by_name_and_description, :against => [:name, :description],
                                                   :using => {
                                                     :tsearch => {:prefix => true}
                                                   }

  def team
    users.order('display_order ASC')
  end

end
