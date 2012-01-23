class Answer < Content
  belongs_to :question,
             :foreign_key => :related_content_id
  has_one :answer_data,
          :dependent => :destroy

  before_create :mark_question_as_answered

  delegate :answer_text, :video_data, :to => :answer_data, :allow_nil => true
  delegate :question_text, :to => :question, :allow_nil => true

  accepts_nested_attributes_for :answer_data

  def self.from_area(area)
    joins(:author => :areas).moderated.where('areas.id' => area.id)
  end

  def self.answer_time
    joins(:question).select('extract(epoch from avg(contents.published_at - questions_contents.published_at)) as moderation_time').first.moderation_time.try(:to_f) || 0
  end

  def parent
    question
  end

  def text
    answer_text
  end

  def text_for_slug
    question.text
  end

  def question_published_at
    question.published_at
  end

  def as_json(options = {})
    super({
      :question_id           => question.try(:id),
      :question_slug         => question.try(:slug),
      :question_text         => question_text,
      :question_published_at => question_published_at,
      :has_video             => (video_data.present? rescue nil),
      :answer_text           => answer_text
    })
  end

  def publish
    return if self.author.blank?

    @to_update_public_streams  = (to_update_public_streams || [])
    @to_update_private_streams = (to_update_private_streams || [])

    @to_update_private_streams = (to_update_private_streams || [])
    @to_update_private_streams << question.author
    @to_update_private_streams += question.answer_requests.map(&:author)

    super
  end

  def send_mail
    IrekiaMailer.deliver_question_answered(self) if moderated?
  end

  def mark_question_as_answered
    question.mark_as_answered(published_at) if question
  end
  private :mark_question_as_answered

end
