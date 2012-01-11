class AnswerData < ActiveRecord::Base
  belongs_to :answer,
             :foreign_key => :answer_id
  has_one :video_data

  accepts_nested_attributes_for :video_data, :allow_destroy => true

  def video_data_attributes=(attributes)
    create_video_data(attributes) if attributes['video_url'].present?
  end
end
