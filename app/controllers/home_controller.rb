class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    get_areas
    get_actions
    get_site_counters
    render :partial => 'shared/actions_list' and return if request.xhr?
  end

  def nav_bar_buttons
    render :partial => 'shared/nav_bar_buttons', :layout => false
  end

  def agenda
    @agenda, @days, @agenda_json = Event.general_agenda(params.slice(:next_month))

    render :partial => 'shared/agenda_list',
           :layout  => nil and return if request.xhr?
  end

  def get_areas
    @areas                 = Area.areas_for_homepage
    @areas_by_name         = Area.names_and_ids.all
  end
  private :get_areas

  def get_actions
    @actions               = AreaPublicStream.for_homepage
    @news_count            = @actions.news.count            || 0
    @questions_count       = @actions.questions.count       || 0
    @answers_count         = @actions.answers.count         || 0
    @proposals_count       = @actions.proposals.count       || 0
    @arguments_count       = @actions.arguments.count       || 0
    @votes_count           = @actions.votes.count           || 0
    @photos_count          = @actions.photos.count          || 0
    @videos_count          = @actions.videos.count          || 0
    @status_messages_count = @actions.status_messages.count || 0
    @tweets_count          = @actions.tweets.count          || 0

    @actions = @actions.where(:event_type => [params[:type]].flatten.map(&:camelize)) if params[:type]
    @actions = @actions.page(1).per(10).sort{|a, b| b.published_at <=> a.published_at}
  end
  private :get_actions

  def get_site_counters
    @all_citizens           = User.citizens.count
    @all_politicians        = User.politicians.count
    @all_questions          = Question.moderated.count
    @all_questions_answered = Question.moderated.answered.count
    @all_proposals          = Proposal.moderated.count
    @all_votes              = Vote.count
  end
  private :get_site_counters
end
