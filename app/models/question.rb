class Question < Content
  has_one :question_data,
          :foreign_key => :question_id

  has_one :answer_data
  has_one :answer,
          :through => :answer_data
  has_many :answer_requests,
           :foreign_key => :content_id

  scope :answered, joins(:answer)
  scope :not_answered, includes(:answer_data).where('answer_data.question_id IS NULL')

  accepts_nested_attributes_for :question_data, :answer_requests, :answer

  delegate :question_text, :to => :question_data

  def as_json(options = {})
    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image_thumb_url
      },
      :published_at    => published_at,
      :question_text   => question_text,
      :target_user     => {
        :id   => question_data.try(:target_user).try(:id),
        :name => question_data.try(:target_user).try(:name)
      },
      :answered_at     => try(:answer).try(:published_at),
      :comments        => comments.count
    }

    {
      :question     => self.question_text,
      :published_at => self.published_at,
      :authors      => self.users.map{|u| {:id => u.id, :name => u.name}},
      :target_area  => target_area_json,
      :target_user  => target_user_json
    }.to_json
  end
end
