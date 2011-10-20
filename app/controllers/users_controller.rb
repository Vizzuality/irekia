class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:intro, :new, :create, :show, :questions, :proposals, :actions, :followings]
  before_filter :private_politician_or_public?
  before_filter :get_user, :only => [:show, :edit, :update, :connect, :questions, :proposals, :actions, :followings, :agenda]
  before_filter :get_questions, :only => [:questions]
  before_filter :get_proposals, :only => [:proposals]
  before_filter :get_actions, :only => [:show, :actions]
  before_filter :get_agenda, :only => [:agenda]
  before_filter :log_user_connection_time, :only => [:show]

  def show
    redirect_to_politician_page?

    @first_time = @user.first_time
    @user.update_attribute('first_time', false) if @first_time

    @suggestions         = @user.follow_suggestions.limit(6)
    @suggestions_follows = @suggestions.inject({}) do |suggestions_follows, user|
      suggestions_follows[user.id] = if @user.blank? || @user.not_following(user)
        follow          = user.follows.build
        follow.user     = @user
        follow
      else
        follow = @user.followed_item(user)
      end
      suggestions_follows
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

    unless public_profile?
      @areas_follows   = Hash[@user.followed_items.areas.map{|follow| [follow.follow_item_id, follow]}]
      @users_follows   = Hash[@user.followed_items.users.map{|follow| [follow.follow_item_id, follow]}]
    end
  end

  def agenda

  end

  def intro
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create params[:user]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      env['warden'].set_user(@user)
      redirect_to edit_user_path(@user)
    else
      render :new
    end
  end

  def edit
    session[:return_to] = connect_user_path(@user)
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = :question_created if params['user']['question_data_attributes'].present?
    else
      flash[:notice] = :question_failed if params['user']['question_data_attributes'].present?
    end

    redirect_back_or_default user_path(@user)
  end

  def connect
    session[:return_to] = connect_user_path(@user)
  end

  def redirect_to_politician_page?
    redirect_to politician_path(@user) if current_user.blank? || (@user.politician? && current_user != @user)
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

  def get_user
    return unless params[:id].present?

    @user                  = User.by_id(params[:id])
    @users_following       = @user.users_following.politicians.all
    @areas_following       = @user.areas_following.all
    @answers_count         = current_user.answers_count if current_user
    @followers_count       = @user.followers.count
    @new_followers_count   = @user.new_followers(last_seen_at).count
  end
  private :get_user

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
      @questions_top = if params[:more_polemic]
        @questions_top.more_polemic
      else
        @questions_top.more_recent
      end
      @questions_top_count = @questions_top.length
      @questions = @questions_top if params[:referer] == 'answered'
    end

    if params[:referer].blank? || params[:referer] == 'all'
      @questions = if params[:more_polemic]
        @questions.more_polemic
      else
        @questions.more_recent
      end
    end
    @questions = @questions.all if @questions
    @questions_top = @questions_top.all if @questions_top
  end
  private :get_questions

  def get_proposals
    @proposals = @user.proposals_done.moderated

    @proposals = if params[:more_polemic]
    @proposals.more_polemic
    else
    @proposals.more_recent
    end
    @proposals_count          = @proposals.count
    @proposals_in_favor_count = @proposals.approved_by_majority.count
    @proposals                = @proposals.all if @proposals
  end
  private :get_proposals

  def get_actions
    if action_name == 'show' && private_profile?
      user_actions = @user.actions.limit(5)
      @actions     = user_actions + @user.followings_actions.limit(10 - user_actions.length)
    else
      @actions = @user.actions
      @actions = @actions.where(:event_type => params[:type]) if params[:type].present?

      @actions = if params[:more_polemic]
        @actions.more_polemic
      else
        @actions.more_recent
      end
      @actions = @actions.page(params[:page]).per(10).all
    end
  end
  private :get_actions

  def get_agenda
    @beginning_of_calendar = Date.current.beginning_of_week
    @end_of_calendar       = Date.current.advance(:weeks => 4).end_of_week

    @agenda = @user.agenda_between(@beginning_of_calendar, @end_of_calendar)
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
  private :get_agenda

  def private_profile?
    @viewing_access == 'private'
  end
  private :private_profile?

  def public_profile?
    @viewing_access == 'public'
  end
  private :private_profile?

  def politician_profile?
    @viewing_access == 'politician'
  end
  private :private_profile?

  def log_user_connection_time
    cookies[:last_seen_at] = DateTime.now if user_signed_in?
  end
  private :log_user_connection_time

  def last_seen_at
    DateTime.parse(cookies[:last_seen_at]) rescue nil
  end
  private :last_seen_at

end
