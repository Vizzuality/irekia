class PoliticiansController < UsersController
  skip_before_filter :authenticate_user!, :only => [:show, :actions, :questions, :proposals, :agenda, :detail]

  before_filter :per_page,                   :only => [:show, :actions, :questions, :proposals]
  before_filter :get_user,                   :only => [:show, :update, :actions, :questions, :proposals, :agenda, :detail]
  before_filter :models_for_forms,           :only => [:show, :update, :actions, :questions, :proposals, :agenda]
  before_filter :current_user_is_politician?
  before_filter :get_politician,             :only => [:show, :update, :actions, :questions, :proposals, :agenda, :detail]
  before_filter :get_politician_data,        :only => [:show, :actions, :questions, :proposals, :agenda, :detail]
  before_filter :get_counters,               :only => [:show, :actions, :questions, :proposals, :agenda]
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

  def detail

  end

  def current_user_is_politician?
    redirect_to user_path(current_user) if current_user.present? && params[:id].to_i == current_user.id && current_user.politician?
  end
  private :current_user_is_politician?

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
    @followers_count       = @politician.followers.count       || 0
    @news_count            = @politician.news_count            || 0
    @questions_count       = @politician.questions_count       || 0
    @answers_count         = @politician.answers_count         || 0
    @proposals_count       = @politician.proposals_count       || 0
    @arguments_count       = @politician.arguments_count       || 0
    @votes_count           = @politician.votes_count           || 0
    @photos_count          = @politician.photos_count          || 0
    @videos_count          = @politician.videos_count          || 0
    @status_messages_count = @politician.status_messages_count || 0
    @tweets_count          = @politician.tweets_count          || 0
  end
  private :get_counters

  def get_actions
    @actions = @politician.get_actions(params.slice(:type, :more_polemic))
  end
  private :get_actions

  def get_questions
    @questions = @politician.get_questions(params.slice(:answered, :more_polemic))
  end
  private :get_questions

  def get_proposals
    @proposals = @politician.get_proposals(params.slice(:from_politicians, :from_citizens, :more_polemic))
  end
  private :get_proposals

  def get_agenda
    weeks = action_name == 'show' ? 1 : 3

    @agenda, @days, @agenda_json = @politician.agenda_between(weeks, params.slice(:next_month))
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
    @proposals = @proposals.page(1).per(@per_page).all if @proposals
    @questions = @questions.page(1).per(@per_page).all if @questions
  end
  private :paginate
end
