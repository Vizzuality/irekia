class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index

  end

  def nav_bar_buttons
    render :partial => 'shared/nav_bar_buttons'
  end
end
