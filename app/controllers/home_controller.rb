class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    @areas                 = Area.areas_for_homepage
    @areas_by_name         = Area.names_and_ids.all
    @actions               = AreaPublicStream.where('event_type <> ?', 'Photo').order('published_at desc')
    @actions               = @actions.where(:event_type => params[:type].camelize) if params[:type]
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

    @actions = @actions.page(1).per(10)

    render :partial => 'shared/actions_list' and return if request.xhr?
  end

  def nav_bar_buttons
    render :partial => 'shared/nav_bar_buttons', :layout => false
  end
end
