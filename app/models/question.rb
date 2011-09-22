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

  scope :answered, joins(:answer_data)
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
      :name => question_data.try(:target_user).try(:fullname)
    } if question_data.target_user

    {
      :author          => {
        :id            => author.id,
        :name          => author.name,
        :fullname      => author.fullname,
        :profile_image => author.profile_image
      },
      :id              => id,
      :published_at    => published_at,
      :question_text   => question_text,
      :target_user     => target_user,
      :answered_at     => try(:answer).try(:published_at),
      :comments_count  => comments_count,
      :last_comments   => last_comments
    }
  end

  def publish_content

    return unless self.moderated?

    if target_user
      user_action              = target_user.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name.downcase
      user_action.published_at = self.published_at
      user_action.message      = self.to_json
      user_action.save!

      target_user.update_attribute('questions_count', target_user.questions_count + 1)
    end
    super
  end
  private :publish_content
end
