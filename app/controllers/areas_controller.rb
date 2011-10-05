class AreasController < ApplicationController

  skip_before_filter :authenticate_user!,    :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_area,                   :only => [:show, :update, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_area_data,              :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :get_actions,                :only => [:show, :actions, :questions, :proposals, :agenda, :team]
  before_filter :build_questions_for_update, :only => [:questions]
  before_filter :get_questions,              :only => [:show, :questions]
  before_filter :get_proposals,              :only => [:show, :proposals]
  before_filter :get_agenda,                 :only => [:show, :agenda]

  respond_to :html, :json

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
    render :partial => 'shared/actions_list', :layout => nil if request.xhr?
  end

  def questions
    render :partial => 'shared/questions_list', :layout => nil and return if request.xhr?
    @question_target    = @area
    session[:return_to] = questions_area_path(@area)
  end

  def proposals
    render :partial => 'shared/proposals_list', :layout => nil and return if request.xhr?
  end

  def agenda
  end

  def team
  end

  private
  def get_area
    @area = Area.where(:id => params[:id]).first if params[:id].present?
  end

  def get_area_data
    @team            = @area.team.includes(:title)
    if current_user.blank? || current_user.not_following(@area)
      @follow          = @area.follows.build
      @follow.user     = current_user
    else
      @follow = current_user.followed_item(@area)
    end
    @follow_parent   = @area
    @followers_count = @follow_parent.followers.count
  end

  def get_actions
    @actions = @area.actions
    @actions = @actions.where(:event_type => params[:type]) if params[:type].present?

    @actions = if params[:more_polemic]
      @actions.more_polemic
    else
      @actions.more_recent
    end

    @actions = @actions.page params[:page]
  end

  def build_questions_for_update
    return if current_user.blank?
    @question                  = Question.new
    @question.contents_users   << ContentUser.new(:user => current_user)
    @question_data             = @question.build_question_data
    @question_data.target_area = @area
  end

  def get_questions
    @questions = @area.questions.moderated
    @questions = @questions.answered if params[:answered]

    @questions = if params[:more_polemic]
      @questions.more_polemic
    else
      @questions.more_recent
    end
  end

  def get_proposals
    @proposals = @area.proposals.moderated
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
      @end_of_calendar       = Date.current.advance(:weeks => 3).end_of_week
    end

    @agenda = @area.events.moderated.where('event_data.event_date >= ? AND event_data.event_date <= ?', @beginning_of_calendar, @end_of_calendar)
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
