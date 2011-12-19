class AreasController < ApplicationController

  skip_before_filter :authenticate_user!,    :only => [:index, :show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_area,                   :only => [:show, :update, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_area_data,              :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_counters,               :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :build_new_question,         :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :build_new_proposal,         :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_actions,                :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_questions,              :only => [:show, :questions]
  before_filter :get_proposals,              :only => [:show, :proposals]
  before_filter :get_agenda,                 :only => [:show, :agenda]
  before_filter :paginate,                   :only => [:show, :actions, :questions, :proposals]

  respond_to :html, :json

  def index
    @all_areas = Area.includes(:image).order('name').all

    render :layout => !request.xhr?
  end

  def show
  end

  def update

    if @area.update_attributes(params[:area])
      flash[:notice] = :question_created if params['area']['questions_attributes'].present?
    else
      flash[:notice] = :question_failed if params['area']['questions_attributes'].present?
    end

    redirect_back_or_default area_path(@area)
  end

  def actions
    render :partial => 'shared/actions_list', :layout  => nil and return if request.xhr?
  end

  def questions
    render :partial => 'shared/questions_list',
           :layout  => nil and return if request.xhr?

    session['user_return_to'] = questions_area_path(@area)
  end

  def proposals
    render :partial => 'shared/proposals_list', :layout => nil and return if request.xhr?
  end

  def agenda
    render :partial => 'shared/agenda_list',
           :layout  => nil and return if request.xhr?
  end

  def team
  end

  def get_area
    @area = Area.by_id(params[:id])
  end
  private :get_area

  def get_area_data
    if current_user.blank? || current_user.not_following(@area)
      @follow          = @area.follows.build
      @follow.user     = current_user
    else
      @follow = current_user.followed_item(@area)
    end
    @follow_parent   = @area
    @team            = @area.team.all
  end
  private :get_area_data

  def get_counters
    @followers_count       = @area.followers.count       || 0
    @news_count            = @area.news_count            || 0
    @questions_count       = @area.questions_count       || 0
    @answers_count         = @area.answers_count         || 0
    @proposals_count       = @area.proposals_count       || 0
    @arguments_count       = @area.arguments_count       || 0
    @votes_count           = @area.votes_count           || 0
    @photos_count          = @area.photos_count          || 0
    @videos_count          = @area.videos_count          || 0
    @status_messages_count = @area.status_messages_count || 0
    @tweets_count          = @area.tweets_count          || 0
  end
  private :get_counters

  def build_new_question
    @question                  = Question.new
    @question.areas_contents   << @question.areas_contents.build(:area => @area)
    @question_data             = @question.build_question_data
    @question_data.target_area = @area
  end
  private :build_new_question

  def build_new_proposal
    @proposal                  = Proposal.new
    @proposal.areas_contents   << @proposal.areas_contents.build(:area => @area)
    @proposal_data             = @proposal.build_proposal_data
    @proposal_data.target_area = @area
    @proposal_data.image       = @proposal_data.build_image
  end
  private :build_new_proposal

  def get_actions
    @actions = @area.get_actions(params.slice(:type, :more_polemic), current_user)
  end
  private :get_actions

  def get_questions
    @questions = @area.get_questions(params.slice(:answered, :more_polemic), current_user)
  end
  private :get_questions

  def get_proposals
    @proposals = @area.get_proposals(params.slice(:from_politicians, :from_citizens, :more_polemic), current_user)
  end
  private :get_proposals

  def get_agenda
    weeks = action_name == 'show' ? 1 : 3

    @agenda, @days, @agenda_json = @area.agenda_between(weeks, params.slice(:next_month))
  end
  private :get_agenda

  def paginate
    if action_name == 'show' || params[:referer] == 'show'
      @per_page = 5
      @actions   = @actions.page(1).per(@per_page).all   if @actions
      @questions = @questions.page(1).per(@per_page).all if @questions
      @proposals = @proposals.page(1).per(@per_page).all if @proposals
    else
      @per_page = 10
      @actions   = @actions.page(params[:page]).per(@per_page).all   if @actions
      @questions = @questions.page(params[:page]).per(@per_page).all if @questions
      @proposals = @proposals.page(params[:page]).per(@per_page).all if @proposals
    end
  end
  private :paginate

end
