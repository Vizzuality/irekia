class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    @areas           = Area.select([:id, :name]).order(:id).all
    @actions         = AreaPublicStream.order('published_at desc').page(1).per(10)
    @news_count      = @actions.news.count
    @questions_count = @actions.questions.count
    @answers_count   = @actions.answers.count
    @proposals_count = @actions.proposals.count
    @arguments_count = @actions.arguments.count
    @votes_count     = @actions.votes.count
    @photos_count    = @actions.photos.count
    @videos_count    = @actions.videos.count
    @statuses_count  = @actions.status_messages.count

    render :partial => 'shared/actions_list' and return if request.xhr?
  end

  def nav_bar_buttons
    render :partial => 'shared/nav_bar_buttons', :layout => false
  end
end
