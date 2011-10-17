class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:intro, :new, :create, :show, :questions, :proposals, :actions, :followings]
  before_filter :private_or_public?
  before_filter :get_user, :only => [:show, :edit, :update, :connect, :questions, :proposals, :actions, :followings]
  before_filter :get_questions, :only => [:questions]
  before_filter :get_proposals, :only => [:proposals]
  before_filter :get_actions, :only => [:show, :actions]

  def show
    redirect_to politician_path(@user) if @user.politician?

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
           :locals  => {:questions => @questions},
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
    @areas_following = @user.followed_items.areas
    @users_following = @user.followed_items.users
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

  def private_or_public?
    @viewing_access = if current_user && params[:id].present? && current_user.id == params[:id].to_i
      'private'
    else
      'public'
    end
  end
  private :private_or_public?

  def get_section
    @section = params[:section] || 'dashboard'
  end
  private :get_section

  def get_user
    @user                  = User.where(:id => params[:id]).first if params[:id].present?
    @politicians_following = @user.users_following.politicians
    @areas_following       = @user.areas_following
    @answers_count         = current_user.answers_count if current_user
  end
  private :get_user

  def get_questions
    if ( params[:referer].blank? || params[:referer] == 'answered' ) && private_profile?
      @questions_answered = @user.questions.answered
      @questions_answered = if params[:more_polemic]
        @questions_answered.more_polemic
      else
        @questions_answered.more_recent
      end
      @questions_answered_count = @questions_answered.length
      @questions = @questions_answered if params[:referer] == 'answered'
    end

    if params[:referer].blank? || params[:referer] == 'all'
      @questions = @user.questions
      @questions = if params[:more_polemic]
        @questions.more_polemic
      else
        @questions.more_recent
      end
    end
  end

  def get_proposals
    @proposals = @user.proposals_done.moderated

    @proposals = if params[:more_polemic]
      @proposals.more_polemic
    else
      @proposals.more_recent
    end
    @proposals_count = @proposals.count
    @proposals_in_favor_count = 0
  end

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
      @actions = @actions.page(params[:page]).per(10)
    end
  end
  private :get_actions

  def private_profile?
    current_user == @user
  end
  private :private_profile?
end
