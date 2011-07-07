class ContentUser < ActiveRecord::Base
  belongs_to :content
  belongs_to :user
  belongs_to :question, :foreign_key => :content_id
  belongs_to :proposal, :foreign_key => :content_id

  accepts_nested_attributes_for :question
end
