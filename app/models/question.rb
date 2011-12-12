class Question < Content
  include PgSearch

  has_one :question_data,
          :foreign_key => :question_id,
          :include => :target_user,
          :select => 'id, question_id, user_id, area_id, question_text, answered_at'

  has_one :answer,
          :foreign_key => :related_content_id,
          :include => [:answer_data, {:author => :profile_pictures}]

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

  delegate :target_area, :target_user, :question_text, :answered_at, :to => :question_data, :allow_nil => true

  def self.answered
    joins(:question_data).where('question_data.answered_at IS NOT NULL')
  end

  def self.not_answered
    includes(:question_data).where('question_data.answered_at IS NULL')
  end

  def self.from_area(area)
    select('contents.id, contents.user_id, contents.type, contents.published_at, contents.moderated, contents.answer_requests_count')
    .includes({:author => :profile_pictures}, :question_data, :comments)
    .joins(:question_data)
    .moderated
    .where('question_data.area_id = ? OR question_data.user_id IN (?)', area.id, area.user_ids)
    .order('published_at desc')
  end

  def self.from_politician(politician)
    joins(:question_data)
    .moderated
    .where('question_data.user_id = ? OR question_data.area_id in (?)', politician.id, politician.area_ids)
  end

  def text
    question_text
  end

  def mark_as_answered(answered_at)
    question_data.update_attribute('answered_at', answered_at)
  end

  def as_json(options = {})
    target_user = {
      :id       => self.target_user.try(:id),
      :fullname => self.target_user.try(:fullname)
    } if self.target_user

    target_area = {
      :id   => self.target_area.try(:id),
      :name => self.target_area.try(:name)
    } if self.target_area

    super({
      :question_text         => question_text,
      :answer_requests_count => answer_requests_count,
      :target_user           => target_user,
      :target_area           => target_area,
      :answered_at           => answered_at
    })
  end

  def update_answer_requests_count
    update_attribute('answer_requests_count', answer_requests.count)
  end

  def facebook_share_message
    question_text.truncate(140)
  end

  def twitter_share_message
    question_text.truncate(140)
  end

  def email_share_message
    question_text
  end

  def publish

    return unless self.moderated?

    user_action              = author.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
    user_action.published_at = self.published_at
    user_action.message      = self.to_json
    user_action.save!

    if target_user
      user_action              = target_user.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
      user_action.published_at = self.published_at
      user_action.message      = self.to_json
      user_action.save!

      target_user.areas.each do |area|
        area_action              = area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
        area_action.published_at = self.published_at
        area_action.message      = self.to_json
        area_action.save!

        area.followers.each do |follower|
          user_action              = follower.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
          user_action.published_at = self.published_at
          user_action.message      = self.to_json
          user_action.save!
        end
      end

      target_user.followers.each do |follower|
        user_action              = follower.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
        user_action.published_at = self.published_at
        user_action.message      = self.to_json
        user_action.save!
      end
    elsif target_area
      area_action              = target_area.actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
      area_action.published_at = self.published_at
      area_action.message      = self.to_json
      area_action.save!

      target_area.team.each do |politician|
        user_action              = politician.private_actions.find_or_create_by_event_id_and_event_type self.id, self.class.name
        user_action.published_at = self.published_at
        user_action.message      = self.to_json
        user_action.save!
      end
    end
  end

  def notification_for(user)
    if target_user.present?
      Notification.for(target_user, self)
    elsif target_area.present?
      target_area.team.each{|politician| Notification.for(politician, self)}
    end
  end

end
