class DemoController < ApplicationController

  skip_before_filter :authenticate_user!

  def index

  end

  def slideshow
    render :layout => "slideshow"
  end

  def datamapper
    render :layout => "datamapper"
  end

end

