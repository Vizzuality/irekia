class ApplicationController < ActionController::Base
  clear_helpers
  protect_from_forgery
  before_filter :authenticate_user!

  before_filter :get_areas
  before_filter :setup_search

  def get_areas
    @areas = Area.all
  end
  private :get_areas

  def setup_search
    @search = OpenStruct.new(params[:search])
  end
  private :setup_search

  def redirect_back_or_default(*default)
    if session[:return_to].nil?
      redirect_to default
    else
      redirect_to session[:return_to]
      session[:return_to] = nil
    end
  end
  private :redirect_back_or_default

  def redirect_back_or_render_action(action)
    if session[:return_to].nil?
      render action
    else
      redirect_to session[:return_to]
      session[:return_to] = nil
    end
  end
  private :redirect_back_or_render_action
end
