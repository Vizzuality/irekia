class ApplicationController < ActionController::Base
  rescue_from Exception,                           :with => :render_error
  rescue_from ActiveRecord::RecordNotFound,        :with => :render_not_found
  rescue_from ActionController::RoutingError,      :with => :render_not_found
  rescue_from ActionController::UnknownController, :with => :render_not_found
  rescue_from ActionController::UnknownAction,     :with => :render_not_found

  clear_helpers
  protect_from_forgery
  before_filter :authenticate_user!, :except => [:render_error, :render_not_found, :in_development]

  before_filter :get_areas
  before_filter :setup_search

  def render_error(exception)
    logger.error exception
    render :partial => 'shared/error', :status => 500
  end

  def render_not_found
    render :partial => 'shared/not_found', :status => 404
  end

  def in_development
    render :partial => 'shared/in_development'
  end

  def get_areas
    @areas = Area.all
  end
  private :get_areas

  def setup_search
    @search = OpenStruct.new(params[:search])
  end
  private :setup_search

  def redirect_back_or_default(default)
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
