class AreaContent < ActiveRecord::Base
  belongs_to :area
  belongs_to :content
  belongs_to :question, :foreign_key => :content_id
  belongs_to :proposal, :foreign_key => :content_id
end
