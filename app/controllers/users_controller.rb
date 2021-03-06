class UsersController < ApplicationController
  skip_before_filter :authenticate_user!,      :only => [:intro, :preregister, :register, :new, :create, :show, :questions, :proposals, :actions, :followings, :edit]
  before_filter :per_page,                     :only => [:show, :actions, :questions, :proposals]
  before_filter :get_user,                     :only => [:show, :edit, :update, :connect, :questions, :proposals, :actions, :followings, :agenda, :settings]
  before_filter :get_follow_suggestions,       :only => [:show, :followings]
  before_filter :get_counters,                 :only => [:show, :questions, :proposals, :actions, :followings, :agenda]
  before_filter :models_for_forms,             :only => [:show, :edit, :update, :connect, :questions, :proposals, :actions, :followings, :agenda]
  before_filter :get_questions,                :only => [:questions]
  before_filter :get_proposals,                :only => [:proposals]
  before_filter :get_actions,                  :only => [:show, :actions]
  before_filter :get_agenda,                   :only => [:agenda]
  before_filter :paginate,                     :only => [:show, :actions, :questions, :proposals]

  respond_to :html, :json, :ics, :iphone

  def show
    redirect_to_politician_page?
  end

  def questions
    if current_user && !request.xhr?
      if private_profile?
        current_user.reset_counter('new_answers')
        current_user.reset_counter('new_answer_requests')
      elsif politician_profile?
        current_user.reset_counter('new_questions')
      end
      @questions_notifications = 0
    end

    render :partial => 'shared/questions_list',
           :layout  => nil and return if request.xhr?
  end

  def proposals
    if current_user && !request.xhr?
      current_user.reset_counter('new_arguments')
      current_user.reset_counter('new_votes')
      @proposals_notifications = 0
    end

    render :partial => 'shared/proposals_list',
           :layout  => nil and return if request.xhr?
  end

  def actions
    render :partial => 'shared/actions_list', :layout  => nil and return if request.xhr?
  end

  def followings
    @areas_following  = @user.areas_following.all
    @users_following  = @user.users_following.all
    @followings_count = @areas_following.size + @users_following.size

    if private_profile?
      @areas_follows   = Hash[@user.followed_items.areas.map{|follow| [follow.follow_item_id, follow]}]
      @users_follows   = Hash[@user.followed_items.users.map{|follow| [follow.follow_item_id, follow]}]
    elsif public_profile?
      @areas_follows   = Hash[@areas_following.map{|area| [area.id, current_user ? current_user.follow_for(area) : Follow.new(:follow_item => area)]}]
      @users_follows   = Hash[@users_following.map{|user| [user.id, current_user ? current_user.follow_for(user) : Follow.new(:follow_item => user)]}]
    end
  end

  def agenda
    render :partial => 'shared/agenda_list',
           :layout  => nil and return if request.xhr?

    respond_with @agenda do |format|
      format.html
      format.ics do
        render :text => Event.to_calendar(@agenda)
      end
    end
  end

  def intro
  end

  def new
    session[:new_user] = {}
    @user = User.new
    render :layout => !request.xhr?
  end

  def preregister
    @user                       = User.new(params[:user])
    @user.password              = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    @user.valid?
    unless @user.errors.on(:email) || @user.errors.on(:password) || @user.errors.on(:terms_of_service)
      session[:new_user] = {
        :email                 => @user.email,
        :password              => @user.password,
        :password_confirmation => @user.password_confirmation,
        :terms_of_service      => @user.terms_of_service
      }
      redirect_to register_users_path
    else
      render :json => @user.errors.to_json, :status => :error
    end
  end

  def register
    @user = User.new(session[:new_user])
    render :layout => !request.xhr?
  end

  def create
    @user = User.new(session[:new_user])
    @user.password              = session[:new_user][:password]
    @user.password_confirmation = session[:new_user][:password_confirmation]
    @user.email                 = params[:user][:email] if params[:user][:email].present?
    @user.name                  = params[:user][:name]
    @user.lastname              = params[:user][:lastname]
    @user.postal_code           = params[:user][:postal_code]
    @user.birthday              = Date.civil(params[:user][:"birthday(1i)"].to_i,params[:user][:"birthday(2i)"].to_i,params[:user][:"birthday(3i)"].to_i) rescue nil
    @user.locale = I18n.locale

    if @user.save
      sign_in(@user, :bypass => true)
      session[:new_user] = nil

      respond_with(@user) do |format|
        format.html
        format.json
      end
    else
      render :json => @user.errors, :status => :error
    end

  end

  def edit
    session['user_return_to'] = user_path(@user)
    render :layout => !request.xhr?
  end

  def update
    if current_user.update_with_email_and_password params[:user]
      sign_in(current_user, :bypass => true)
    end

    respond_with(current_user) do |format|
      format.html {

        flash[:error] = "password" if current_user.errors[:current_password].present? or current_user.errors[:password].present? or current_user.errors[:email].present?
        render :settings
      }
      format.json
    end
  end

  def destroy
    user_locale = current_user.locale
    if current_user.destroy
      redirect_to byebye_path(:locale => user_locale)
    else
      render :settings
    end
  end

  def connect
    session['user_return_to'] = connect_user_path(@user)
    render :layout => !request.xhr?
  end

  def settings
    session['user_return_to'] = settings_user_path(@user)
  end

  def redirect_to_politician_page?
    redirect_to politician_path(@user) if @user.politician? unless current_user == @user
  end
  private :redirect_to_politician_page?

  def get_section
    @section = params[:section] || 'dashboard'
  end
  private :get_section

  def get_follow_suggestions
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
  private :get_follow_suggestions

  def get_user
    @user            = params[:id].present? ? User.by_id(params[:id]) : current_user

    @users_following = @user.users_following.politicians.all
    @areas_following = @user.areas_following.all

    @viewing_access = if current_user.present? && @user == current_user
      current_user.politician?? 'politician' : 'private'
    else
      'public'
    end

    if private_profile?
      @first_time      = @user.first_time
      @random_area = Area.select([:id, :slug_es, :slug_eu, :slug_en]).all.sample
    end

  end
  private :get_user

  def get_counters
    @followers_count       = @user.followers.count                                                     || 0
    @questions_done_count  = @user.questions.count                                                     || 0
    @proposals_done_count  = @user.proposals.count                                                     || 0
    @news_count            = @user.send("#{'private_' if show_private_actions?}news_count")            || 0
    @questions_count       = @user.send("#{'private_' if show_private_actions?}questions_count")       || 0
    @answers_count         = @user.send("#{'private_' if show_private_actions?}answers_count")         || 0
    @proposals_count       = @user.send("#{'private_' if show_private_actions?}proposals_count")       || 0
    @arguments_count       = @user.send("#{'private_' if show_private_actions?}arguments_count")       || 0
    @votes_count           = @user.send("#{'private_' if show_private_actions?}votes_count")           || 0
    @photos_count          = @user.send("#{'private_' if show_private_actions?}photos_count")          || 0
    @videos_count          = @user.send("#{'private_' if show_private_actions?}videos_count")          || 0
    @status_messages_count = @user.send("#{'private_' if show_private_actions?}status_messages_count") || 0
    @tweets_count          = @user.send("#{'private_' if show_private_actions?}tweets_count")          || 0
    @unanswered_questions_count = @user.get_questions(params.slice(:to_you, :to_your_area)).not_answered.length if @user.politician? && request.format.iphone?

    if politician_profile?
      @followers_count         = @user.followers.count
      @new_followers_count     = @user.new_follows_count
      @questions_notifications = @user.new_questions_count
    else
      @questions_notifications = @user.new_answers_count + @user.new_answer_requests_count
    end
    @proposals_notifications = @user.new_arguments_count + @user.new_votes_count
  end
  private :get_counters

  def models_for_forms
    @question                  = Question.new
    @question_data             = @question.build_question_data
    @question_data.target_user = @user

    @proposal                  = Proposal.new
    @proposal_data             = @proposal.build_proposal_data
    @proposal_data.target_area = @user.areas.first
    @proposal_data.image       = @proposal_data.build_image

    if politician_profile?
      @status_message = StatusMessage.new
      @status_message.status_message_data = @status_message.build_status_message_data

      @photo            = Photo.new
      @photo.image      = @photo.build_image

      @video            = Video.new
      @video.video_data = @video.build_video_data
    end
  end
  private :models_for_forms

  def get_questions
    if public_profile?
      @questions = @user.questions.moderated
    elsif private_profile?
      @questions     = @user.questions
    elsif politician_profile?
      @questions     = @user.get_questions(params.slice(:to_you, :to_your_area))
    end

    if @questions
      @unanswered_questions       = @questions.not_answered if @user.politician?
      @unanswered_questions_count = @unanswered_questions.length if @user.politician?
      @answered_questions_count   = @questions.answered.length     unless @user.politician?
      @questions                  = @questions.answered            if params[:answered].present?

      if params[:referer].blank? || params[:referer] == 'all'
        @questions = if params[:more_polemic] == "true"
          @questions.more_polemic
        else
          @questions.more_recent
        end
      end

    end
  end
  private :get_questions

  def get_proposals
    @proposals = @user.get_proposals(params.slice(:as_author, :from_politicians, :from_citizens, :more_polemic), current_user)

    @proposals_in_favor_count = @proposals.approved_by_majority.count
  end
  private :get_proposals

  def get_actions
    if (action_name == 'show' || params[:referer] == 'show') && (private_profile? || politician_profile?)
      params[:type] = ["question", "answer", "answer_request"] if request.format.iphone?

      @actions = @user.get_private_actions(params.slice(:type, :referer, :more_polemic, :page), current_user)
    else
      @actions = @user.get_actions(params.slice(:type, :referer, :more_polemic, :page), current_user)
    end
    @actions_count = @actions.count
  end
  private :get_actions

  def get_agenda
    @previous_month_counter = -1
    @next_month_counter     = 1
    @previous_month_counter -= params[:next_month].to_i
    @next_month_counter     += params[:next_month].to_i

    @current_date   = Date.current.advance(:months  => params[:next_month].to_i)
    @next_month     = @current_date.advance(:months => 1)
    @previous_month = @current_date.advance(:months => -1)

    @agenda, @days, @agenda_json = @user.agenda_between(4, params.slice(:next_month))
  end
  private :get_agenda

  def per_page
    @page = params[:page] || 0
    @per_page = if action_name == 'show' || params[:referer] == 'show'
                  if request.format.iphone?
                    120
                  else
                    5
                  end
    else
      10
    end
  end
  protected :per_page

  def paginate
    @actions   = @actions.page(params[:page]).per(@per_page + 1).all   if @actions
    @proposals = @proposals.page(params[:page]).per(@per_page + 1).all if @proposals
    @questions = @questions.page(params[:page]).per(@per_page + 1).all if @questions
  end
  protected :paginate

  def private_profile?
    @viewing_access == 'private'
  end
  private :private_profile?

  def show_private_actions?
    (action_name == 'show' || params[:referer] == 'show') && (private_profile? || politician_profile?)
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
