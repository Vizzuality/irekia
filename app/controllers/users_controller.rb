class UsersController < ApplicationController
  skip_before_filter :authenticate_user!,      :only => [:intro, :new, :create, :show, :questions, :proposals, :actions, :followings, :edit]
  skip_before_filter :current_user_valid?,     :only => [:edit, :update]
  before_filter :private_politician_or_public?
  before_filter :user_is_current_user?,        :only => [:edit, :update]
  before_filter :per_page,                     :only => [:show, :actions, :questions, :proposals]
  before_filter :get_user,                     :only => [:show, :edit, :update, :connect, :questions, :proposals, :actions, :followings, :agenda]
  before_filter :get_counters,                 :only => [:show, :actions, :questions, :proposals]
  before_filter :build_new_question,           :only => [:questions]
  before_filter :build_new_proposal,           :only => [:proposals]
  before_filter :get_questions,                :only => [:questions]
  before_filter :get_proposals,                :only => [:proposals]
  before_filter :get_actions,                  :only => [:show, :actions]
  before_filter :get_agenda,                   :only => [:agenda]
  before_filter :paginate,                     :only => [:show, :actions, :questions, :proposals]

  respond_to :html, :json

  def show
    redirect_to_politician_page?


    if current_user
      @suggestions         = current_user.follow_suggestions.limit(6)
      @suggestions_follows = @suggestions.inject({}) do |suggestions_follows, user|
        suggestions_follows[user.id] = if @user.blank? || @user.not_following(user)
          follow          = user.follows.build
          follow.user     = current_user
          follow
        else
          follow = @user.followed_item(user)
        end
        suggestions_follows
      end
    end
  end

  def questions
    if current_user && current_user.answers_count > 0 && !request.xhr?
      current_user.reset_counter('answers')
      @answers_count = 0
    end

    render :partial => 'shared/questions_list',
           :layout  => nil and return if request.xhr?
  end

  def proposals
    render :partial => 'shared/proposals_list',
           :layout  => nil and return if request.xhr?
  end

  def actions
    render :partial => 'shared/actions_list',
           :layout  => nil and return if request.xhr?
  end

  def followings
    @areas_following = @user.areas_following.all
    @users_following = @user.users_following.all

    if private_profile?
      @areas_follows   = Hash[@user.followed_items.areas.map{|follow| [follow.follow_item_id, follow]}]
      @users_follows   = Hash[@user.followed_items.users.map{|follow| [follow.follow_item_id, follow]}]
    elsif public_profile?
      @areas_follows   = Hash[@areas_following.map{|area| [area.id, current_user ? current_user.follow_for(area) : Follow.new(:follow_item => area)]}]
      @users_follows   = Hash[@users_following.map{|user| [user.id, current_user ? current_user.follow_for(user) : Follow.new(:follow_item => user)]}]
    end
  end

  def agenda

  end

  def intro
  end

  def new
    @user = User.new
    render :layout => !request.xhr?
  end

  def create
    @user = User.new params[:user]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      env['warden'].set_user(@user)
      redirect_to edit_user_path(@user)
    else
      render :json => @user.errors.to_json, :status => :error
    end
  end

  def edit
    session[:return_to] = connect_user_path(@user)
    render :layout => !request.xhr?
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = :question_created if params['user']['question_data_attributes'].present?
      redirect_back_or_default user_path(@user)
    else
      flash[:notice] = :question_failed if params['user']['question_data_attributes'].present?
      render :json => @user.errors.to_json, :status => :error
    end
  end

  def connect
    session[:return_to] = connect_user_path(@user)
    render :layout => !request.xhr?
  end

  def redirect_to_politician_page?
    redirect_to politician_path(@user) if @user.politician? unless current_user == @user
  end
  private :redirect_to_politician_page?

  def private_politician_or_public?
    @viewing_access = if current_user && params[:id].present? && current_user.id == params[:id].to_i
      current_user.politician?? 'politician' : 'private'
    else
      'public'
    end
  end
  private :private_politician_or_public?

  def get_section
    @section = params[:section] || 'dashboard'
  end
  private :get_section

  def user_is_current_user?
    redirect_to root_path if current_user.present? && params[:id].to_i != current_user.id
  end
  private :user_is_current_user?

  def get_user
    return unless params[:id].present?

    @user            = User.by_id(params[:id])
    @users_following = @user.users_following.politicians.all
    @areas_following = @user.areas_following.all

    if private_profile?
      @first_time      = @user.first_time
      @random_area = Area.select(:id).all.sample
    end

    if politician_profile?
      @followers_count         = @user.followers.count
      @new_followers_count     = @user.new_follows_count
      @questions_notifications = @user.new_questions_count
    else
      @questions_notifications = @user.new_answers_count + @user.new_answer_requests_count + @user.new_answer_opinions_count
    end
    @proposals_notifications = @user.new_arguments_count + @user.new_votes_count
  end
  private :get_user

  def get_counters
    @followers_count      = @user.followers.count                                               || 0
    @questions_done_count = @user.questions_count                                               || 0
    @proposals_done_count = @user.proposals_count                                               || 0
    @news_count           = @user.send("#{'private_' if show_private_actions?}news_count")      || 0
    @questions_count      = @user.send("#{'private_' if show_private_actions?}questions_count") || 0
    @answers_count        = @user.send("#{'private_' if show_private_actions?}answers_count")   || 0
    @proposals_count      = @user.send("#{'private_' if show_private_actions?}proposals_count") || 0
    @arguments_count      = @user.send("#{'private_' if show_private_actions?}arguments_count") || 0
    @votes_count          = @user.send("#{'private_' if show_private_actions?}votes_count")     || 0
    @photos_count         = @user.send("#{'private_' if show_private_actions?}photos_count")    || 0
    @videos_count         = @user.send("#{'private_' if show_private_actions?}videos_count")    || 0
    @statuses_count       = @user.send("#{'private_' if show_private_actions?}statuses_count")  || 0
  end
  private :get_counters

  def build_new_question
    @question                  = Question.new
    @question_data             = @question.build_question_data
    @question_data.target_user = @user
  end
  private :build_new_question

  def get_questions
    if public_profile?
      @questions = @user.questions.moderated
    elsif private_profile?
      @questions     = @user.questions.moderated
      @questions_top = @questions.answered
    elsif politician_profile?
      @questions     = @user.questions_received.moderated
      @questions_top = @questions.not_answered
    end

    if @questions_top && (params[:referer].blank? || params[:referer] == 'answered')
      @questions_top = if params[:more_polemic] == "true"
        @questions_top.more_polemic
      else
        @questions_top.more_recent
      end
      @questions_top_count = @questions_top.length
      @questions = @questions_top if params[:referer] == 'answered'
    end

    if params[:referer].blank? || params[:referer] == 'all'
      @questions = if params[:more_polemic] == "true"
        @questions.more_polemic
      else
        @questions.more_recent
      end
    end
  end
  private :get_questions

  def build_new_proposal
    @proposal                  = Proposal.new
    @proposal_data             = @proposal.build_proposal_data
    @proposal_data.target_area = @user.areas.first
  end
  private :build_new_proposal

  def get_proposals
    @proposals = @user.get_proposals(params.slice(:from_politicians, :from_citizens, :more_polemic))

    @proposals_count          = @proposals.count
    @proposals_in_favor_count = @proposals.approved_by_majority.count
  end
  private :get_proposals

  def get_actions
    if (action_name == 'show' || params[:referer] == 'show') && private_profile?
      @actions = @user.get_private_actions(params.slice(:type, :referer, :more_polemic, :page))
    else
      @actions = @user.get_actions(params.slice(:type, :referer, :more_polemic, :page))
    end
  end
  private :get_actions

  def get_agenda
    beginning_of_calendar = Date.current.beginning_of_week
    end_of_calendar       = Date.current.advance(:weeks => 4).end_of_week

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
    @proposals = @proposals.page(1).per(@per_page).all if @proposals
    @questions = @questions.all if @questions
    @questions_top = @questions_top.all if @questions_top
  end
  private :paginate

  def private_profile?
    @viewing_access == 'private'
  end
  private :private_profile?

  def show_private_actions?
    (action_name == 'show' || params[:referer] == 'show') && private_profile?
  end
  private :show_private_actions?

  def public_profile?
    @viewing_access == 'public'
  end
  private :private_profile?

  def politician_profile?
    @viewing_access == 'politician'
  end
  private :private_profile?

end
