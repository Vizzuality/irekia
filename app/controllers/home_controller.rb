class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    @areas           = Area.areas_for_homepage
    @areas_by_name   = Area.names_and_ids.all
    @actions         = AreaPublicStream.where('event_type <> ?', 'photo').order('published_at desc')
    @actions         = @actions.where(:event_type => params[:type]) if params[:type]
    @news_count      = @actions.news.count
    @questions_count = @actions.questions.count
    @answers_count   = @actions.answers.count
    @proposals_count = @actions.proposals.count
    @arguments_count = @actions.arguments.count
    @votes_count     = @actions.votes.count
    @photos_count    = @actions.photos.count
    @videos_count    = @actions.videos.count
    @statuses_count  = @actions.status_messages.count

    @actions = @actions.page(1).per(10)

    render :partial => 'shared/actions_list' and return if request.xhr?
  end

  def nav_bar_buttons
    render :partial => 'shared/nav_bar_buttons', :layout => false
  end
end
