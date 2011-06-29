class AreaUser < ActiveRecord::Base
  belongs_to :area
  belongs_to :user

  before_save :set_hierarchy

  private
  def set_hierarchy
    if hierarchy.blank?
      hierarchy = (AreaUser.where(:area_id => area.id).maximum('hierarchy') || 0) + 1
    end
  end
end
