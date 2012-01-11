class DemoController < ApplicationController

  skip_before_filter :authenticate_user!

  def index

  end

  def slideshow
    render :layout => "slideshow"
  end

  def datalogger_login
    render :layout => "datalogger.iphone"
  end

  def datalogger_publish
    render :layout => "datalogger.iphone"
  end

  def datalogger_home
    render :layout => "datalogger.iphone"
  end

end

