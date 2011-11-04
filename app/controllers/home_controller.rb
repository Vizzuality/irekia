class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    @areas = Area.select([:id, :name]).all
  end

  def nav_bar_buttons
    render :partial => 'shared/nav_bar_buttons', :layout => false
  end
end
