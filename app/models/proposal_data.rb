class ProposalData < ActiveRecord::Base
  has_one :image

  belongs_to :proposal,
             :foreign_key => :proposal_id

  belongs_to :target_user,
             :class_name => 'User',
             :foreign_key => :user_id

  belongs_to :target_area,
             :class_name => 'Area',
             :foreign_key => :area_id
end
