class Question < Content
  include PgSearch

  has_one :question_data,
          :foreign_key => :question_id
  has_one :target_user,
          :through => :question_data

  has_one :answer_data
  has_one :answer,
          :through => :answer_data
  has_many :answer_requests,
           :foreign_key => :content_id

  scope :answered, joins(:answer)
  scope :not_answered, includes(:answer_data).where('answer_data.question_id IS NULL')

  pg_search_scope :search_existing_questions, :associated_against => {
    :question_data => :question_text
  },
  :using => {
    :tsearch => {:prefix => true, :dictionary => 'spanish', :any_word => true}
  }

  accepts_nested_attributes_for :question_data, :answer_requests, :answer

  delegate :question_text, :to => :question_data

  def as_json(options = {})
    target_user = {
      :id   => question_data.try(:target_user).try(:id),
      :name => question_data.try(:target_user).try(:name)
    } if question_data.target_user

    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :profile_image => author.profile_image
      },
      :published_at    => published_at,
      :question_text   => question_text,
      :target_user     => target_user,
      :answered_at     => try(:answer).try(:published_at),
      :comments_count  => comments_count
    }
  end
end
