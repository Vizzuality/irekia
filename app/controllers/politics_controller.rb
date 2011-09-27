class PoliticsController < UsersController
  skip_before_filter :authenticate_user!, :only => [:show, :actions, :questions, :proposals, :agenda]

  before_filter :get_user,                   :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :get_politic,                :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :build_questions_for_update, :only => [:show, :actions, :questions, :proposals, :agenda]
  before_filter :get_actions,                :only => [:show, :actions]
  before_filter :get_questions,              :only => [:show, :questions]
  before_filter :get_proposals,              :only => [:show, :proposals]
  before_filter :get_agenda,                 :only => [:show, :agenda]

  def show
    super
    session[:return_to] = politic_path(@politic)
  end

  def actions
    render :partial => 'shared/actions_list', :layout => nil if request.xhr?
  end

  def questions
    @question_target    = @politic
    session[:return_to] = questions_politic_path(@politic)
  end

  def proposals
  end

  def agenda
  end

  private
  def get_politic
    @politic = @user
  end

  def build_questions_for_update
    return if current_user.blank?
    @question                  = current_user.questions.build
    @question_data             = @question.build_question_data
    @question_data.target_user = @user
  end

  def get_actions
    @actions = @politic.actions
    @actions = @actions.where(:event_type => params[:type]) if params[:type].present?

    @actions = if params[:more_polemic]
      @actions.more_polemic
    else
      @actions.more_recent
    end

    @actions = @actions.page params[:page]
 end

  def get_questions
    @questions = @politic.questions_received.moderated
  end

  def get_proposals
    @proposals = @politic.proposals_received.moderated
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

    @agenda = @politic.events.moderated.where('event_data.event_date >= ? AND event_data.event_date <= ?', @beginning_of_calendar, @end_of_calendar)
    @days   = @beginning_of_calendar..@end_of_calendar
  end
end
