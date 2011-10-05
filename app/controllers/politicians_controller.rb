class PoliticiansController < UsersController
  skip_before_filter :authenticate_user!, :only => [:show, :actions, :questions, :proposals, :agenda]

  before_filter :get_user,                   :only => [:show, :update, :actions, :questions, :proposals, :agenda]
  before_filter :get_politician,             :only => [:show, :update, :actions, :questions, :proposals, :agenda]
  before_filter :get_politician_data,        :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :build_questions_for_update, :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :get_actions,                :only => [:show, :actions]
  before_filter :get_questions,              :only => [:show, :questions]
  before_filter :get_proposals,              :only => [:show, :proposals]
  before_filter :get_agenda,                 :only => [:show, :agenda]

  respond_to :html, :json

  def show
    super
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
    render :partial => 'shared/questions_list', :layout => nil and return if request.xhr?
    @question_target    = @politician
    session[:return_to] = questions_politician_path(@politician)
  end

  def proposals
    render :partial => 'shared/proposals_list', :layout => nil and return if request.xhr?
  end

  def agenda
  end

  private
  def get_politician
    @politician = @user
  end

  def get_politician_data
    if current_user.blank? || current_user.not_following(@politician)
      @follow          = @politician.follows.build
      @follow.user     = current_user
    else
      @follow = current_user.followed_item(@politician)
    end
    @follow_parent   = @politician
    @followers_count = @follow_parent.followers.count
  end

  def build_questions_for_update
    @question                  = Question.new
    @question_data             = @question.build_question_data
    @question_data.target_user = @user
    @question_author           = ContentUser.new(:user => current_user) if current_user
  end

  def get_actions
    @actions = @politician.actions
    @actions = @actions.where(:event_type => params[:type]) if params[:type].present?

    @actions = if params[:more_polemic]
      @actions.more_polemic
    else
      @actions.more_recent
    end

    @actions = @actions.page params[:page]
 end

  def get_questions
    @questions = @politician.questions_received.moderated
    @questions = @questions.answered if params[:answered]

    @questions = if params[:more_polemic]
      @questions.more_polemic
    else
      @questions.more_recent
    end
  end

  def get_proposals
    @proposals = @politician.proposals_received.moderated
    @proposals = @proposals.from_politicians if params[:from_politicians]
    @proposals = @proposals.from_citizens if params[:from_citizens]

    @proposals = if params[:more_polemic]
      @proposals.more_polemic
    else
      @proposals.more_recent
    end
  end

  def get_agenda
    case action_name
    when 'show'
      @beginning_of_calendar = Date.current.beginning_of_week
      @end_of_calendar       = Date.current.next_week.end_of_week
    when 'agenda'
      @beginning_of_calendar = Date.current.beginning_of_week
      @end_of_calendar       = Date.current.advance(:weeks => 4).end_of_week
    end

    @agenda = @politician.events.moderated.where('event_data.event_date >= ? AND event_data.event_date <= ?', @beginning_of_calendar, @end_of_calendar)
    @days   = @beginning_of_calendar..@end_of_calendar
    @agenda_json = @agenda.map{|event| {
      :title => event.title,
      :date  => l(event.event_date, :format => '%d, %B de %Y'),
      :when  => event.event_date.strftime('%H:%M'),
      :where => event.location,
      :lat   => event.latitude,
      :lon   => event.longitude
    }}.group_by{|event| [event[:lat], event[:lon]]}.values.to_json.html_safe
  end
end
