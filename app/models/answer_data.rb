class AnswerData < ActiveRecord::Base
  belongs_to :answer,
             :foreign_key => :answer_id
  has_one :video_data

  accepts_nested_attributes_for :video_data, :allow_destroy => true

end
