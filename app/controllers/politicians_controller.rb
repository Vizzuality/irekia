class PoliticiansController < UsersController
  skip_before_filter :authenticate_user!, :only => [:show, :actions, :questions, :proposals, :agenda]

  before_filter :per_page,                   :only => [:show, :actions, :questions, :proposals]
  before_filter :get_user,                   :only => [:show, :update, :actions, :questions, :proposals, :agenda]
  before_filter :get_politician,             :only => [:show, :update, :actions, :questions, :proposals, :agenda]
  before_filter :get_politician_data,        :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :get_counters,               :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :build_new_question,         :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :get_actions,                :only => [:show, :actions]
  before_filter :get_questions,              :only => [:show, :questions]
  before_filter :get_proposals,              :only => [:show, :proposals]
  before_filter :get_agenda,                 :only => [:show, :agenda]
  before_filter :paginate,                   :only => [:show, :actions, :questions, :proposals]

  respond_to :html, :json

  def show
    session[:return_to] = politician_path(@politician)
  end

  def update
    if @politician.update_attributes(params[:user])
      flash[:notice] = :question_created if params['user']['question_data_attributes'].present?
    else
      flash[:notice] = :question_failed if params['user']['question_data_attributes'].present?
    end

    redirect_back_or_default area_path(@politician)
  end

  def actions
    render :partial => 'shared/actions_list', :layout => nil if request.xhr?
  end

  def questions
    render :partial => 'shared/questions_list',
           :layout  => nil and return if request.xhr?

    session[:return_to] = questions_politician_path(@politician)
  end

  def proposals
    render :partial => 'shared/proposals_list', :layout => nil and return if request.xhr?
  end

  def agenda
    render :partial => 'shared/agenda_list',
           :layout  => nil and return if request.xhr?
  end

  def get_politician
    @politician = @user
  end
  private :get_politician

  def get_politician_data
    if current_user.blank? || current_user.not_following(@politician)
      @follow          = @politician.follows.build
      @follow.user     = current_user
    else
      @follow = current_user.followed_item(@politician)
    end
    @follow_parent   = @politician
  end
  private :get_politician_data

  def get_counters
    @followers_count = @politician.followers.count
    @news_count      = @politician.news_count
    @questions_count = @politician.questions_count
    @proposals_count = @politician.proposals_count
    @photos_count    = @politician.photos_count
    @videos_count    = @politician.videos_count
  end
  private :get_counters

  def build_new_question
    @question                  = Question.new
    @question_data             = @question.build_question_data
    @question_data.target_user = @user
  end
  private :build_new_question

  def get_actions
    @actions = @politician.actions
    @actions = @actions.where(:event_type => params[:type]) if params[:type].present?

    @actions = if params[:more_polemic] == 'true'
      @actions.more_polemic
    else
      @actions.more_recent
    end
  end
  private :get_actions

  def get_questions
    @questions = @politician.questions_received.moderated
    @questions = @questions.answered if params[:answered] == "true"

    @questions = if params[:more_polemic] == 'true'
      @questions.more_polemic
    else
      @questions.more_recent
    end
  end
  private :get_questions

  def get_proposals

    @proposals = @politician.proposals_and_participation(params.slice(:from_politicians, :from_citizens, :more_polemic), @page, @per_page)

    @proposal                  = Proposal.new
    @proposal_data             = @proposal.build_proposal_data
    @proposal_data.target_area = @politician.areas.first
  end
  private :get_proposals

  def get_agenda
    calendar_date = Date.current
    if params[:next_month].present?
      calendar_date = Date.current.advance(:months => params[:next_month].to_i)
    end
    beginning_of_calendar = calendar_date.beginning_of_week

    case action_name
    when 'show'
      end_of_calendar = calendar_date.next_week.end_of_week
    when 'agenda'
      end_of_calendar = calendar_date.advance(:weeks => 3).end_of_week
    end

    events = @politician.agenda_between(beginning_of_calendar, end_of_calendar)

    @agenda = events.group_by{|e| e.event_date.day }
    @days   = beginning_of_calendar..end_of_calendar
    @agenda_json = JSON.generate(events.map{|event| {
      :title => event.title,
      :date  => l(event.event_date, :format => '%d, %B de %Y'),
      :when  => event.event_date.strftime('%H:%M'),
      :where => nil,
      :lat   => event.latitude,
      :lon   => event.longitude
    }}.group_by{|event| [event[:lat], event[:lon]]}.values).html_safe
  end
  private :get_agenda

  def per_page
    @page = params[:page] || 0
    @per_page = if action_name == 'show' || params[:referer] == 'show'
      4
    else
      10
    end
  end
  private :per_page

  def paginate
    @actions   = @actions.page(1).per(@per_page).all   if @actions
    @questions = @questions.page(1).per(@per_page).all if @questions
  end
  private :paginate
end
