class Question < Content
  include PgSearch

  has_one :question_data,
          :foreign_key => :question_id,
          :include => :target_user,
          :select => 'id, question_id, user_id, area_id, question_text, body, answered_at'

  has_one :answer,
          :foreign_key => :related_content_id,
          :include => [:answer_data, {:author => :profile_picture}]

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

  delegate :target_area, :target_user, :question_text, :body, :answered_at, :to => :question_data, :allow_nil => true

  after_save :answer_request_from_author

  def self.answered
    joins(:question_data).where('question_data.answered_at IS NOT NULL')
  end

  def self.not_answered
    includes(:question_data).where('question_data.answered_at IS NULL')
  end

  def self.from_area(area, author)
    query = select('contents.id, contents.user_id, contents.type, contents.published_at, contents.moderated, contents.answer_requests_count, contents.slug')
    .includes({:author => :profile_picture}, :question_data, :comments)
    .joins(:question_data)
    .where('question_data.area_id = ? OR question_data.user_id IN (?)', area.id, area.user_ids)
    .order('published_at desc')

    if author.present?
      query.where('contents.moderated = ? OR (contents.moderated = ? AND contents.user_id = ?)', true, false, author.id)
    else
      query.moderated
    end
  end

  def self.from_politician(politician, filters = {})
    query_scope = joins(:question_data).moderated

    if filters.has_key?(:to_you)
      query_scope.where('question_data.user_id = ?', politician.id)
    elsif filters.has_key?(:to_your_area)
      query_scope.where('question_data.area_id in (?)', politician.area_ids)
    else
      query_scope.where('question_data.user_id = ? OR question_data.area_id in (?)', politician.id, politician.area_ids)
    end
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
      :name_es => self.target_area.try(:name_es),
      :name_eu => self.target_area.try(:name_eu),
      :name_en => self.target_area.try(:name_en)
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

  def publish

    @to_update_public_streams = (to_update_public_streams || [])
    @to_update_public_streams << author

    @to_update_private_streams = (to_update_private_streams || [])

    if target_user
      @to_update_public_streams += target_user.areas

      @to_update_private_streams << target_user
      @to_update_private_streams += target_user.areas.map(&:followers).flatten
      @to_update_private_streams += target_user.followers

    elsif target_area
      @to_update_public_streams << target_area
      @to_update_public_streams += target_area.team

      @to_update_private_streams += target_area.team
    end

    super
  end

  def send_mail
    IrekiaMailer.deliver_new_question(self) if moderated?
  end

  def notify_of_new_participation(participation)
    @to_update_private_streams = (to_update_private_streams || [])

    if answer.present?
      @to_update_private_streams << answer.author
    end

    super(participation)
  end

  def answer_request_from_author
    author.answer_requests.create :content_id => id if moderated? && author.has_not_given_his_opinion(self)
  end
  private :answer_request_from_author

end
