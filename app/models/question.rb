class Question < Content
  include PgSearch

  has_one :question_data,
          :foreign_key => :question_id,
          :include => :target_user,
          :select => 'id, question_id, user_id, area_id, question_text, answered_at'

  has_one :answer_data
  has_one :answer,
          :through => :answer_data,
          :include => [:answer_data, :users => :profile_pictures]

  has_many :answer_requests,
           :foreign_key => :content_id

  pg_search_scope :search_existing_questions,
                  :associated_against => {
                    :question_data => :question_text
                  },
                  :using => {
                    :tsearch => {:prefix => true, :any_word => true}
                  }

  accepts_nested_attributes_for :question_data, :answer_requests

  delegate :target_user, :question_text, :answered_at, :to => :question_data

  def self.answered
    joins(:question_data).where('question_data.answered_at IS NOT NULL')
  end

  def self.not_answered
    includes(:question_data).where('question_data.answered_at IS NULL')
  end

  def target_is_a_user?
    question_data.present? && question_data.user_id.present?
  end

  def mark_as_answered(answered_at)
    question_data.update_attribute('answered_at', answered_at)
  end

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
      :answered_at     => answered_at,
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
    end
    super
  end
  private :publish_content

end
