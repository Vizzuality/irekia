class ApplicationController < ActionController::Base
  DEMO_USER = {'virekia' => 'gub5mar'}

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception,                           :with => :render_error
    rescue_from ActiveRecord::RecordNotFound,        :with => :render_not_found
    rescue_from ActionController::RoutingError,      :with => :render_not_found
    rescue_from ActionController::UnknownController, :with => :render_not_found
    rescue_from ActionController::UnknownAction,     :with => :render_not_found
  end

  clear_helpers
  protect_from_forgery
  before_filter :authentication_check
  before_filter :store_user_path
  before_filter :authenticate_user!, :except => [:render_error, :render_not_found, :in_development]
  before_filter :current_user_valid?
  before_filter :get_areas
  before_filter :setup_search

  def authentication_check
    return unless Rails.env.production?

    authenticate_or_request_with_http_basic do |user, password|
      DEMO_USER[user] == password
    end
  end

  def store_user_path
    session[:return_to] = request.fullpath if current_user.blank? && request.get?
  end

  def after_sign_in_path_for(resource)
    if request.xhr?
      session[:return_to] = nil
      nav_bar_buttons_path
    else
      return_to = session[:return_to] || root_path
      session[:return_to] = nil
      return_to.to_s
    end
  end

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

  def current_user_valid?
    redirect_to edit_user_path(current_user) if current_user && current_user.invalid?
  end

  def get_areas
    @areas = Area.names_and_ids.all
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
