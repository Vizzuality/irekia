class QuestionData < ActiveRecord::Base

  belongs_to :question,
             :foreign_key => :question_id

  belongs_to :target_user,
             :class_name => 'User',
             :foreign_key => :user_id

  belongs_to :target_area,
             :class_name => 'Area',
             :foreign_key => :area_id

  accepts_nested_attributes_for :target_user
end
