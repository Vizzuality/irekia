class ProposalData < ActiveRecord::Base
  has_one :image

  belongs_to :proposal,
             :foreign_key => :proposal_id

  belongs_to :target_area,
             :class_name => 'Area',
             :foreign_key => :area_id

  accepts_nested_attributes_for :image

  delegate :content_url, :to => :image

end
