class ApplicationController < ActionController::Base

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception,                           :with => :render_error
    rescue_from AbstractController::ActionNotFound,  :with => :render_not_found
    rescue_from ActiveRecord::RecordNotFound,        :with => :render_not_found
    rescue_from ActionController::RoutingError,      :with => :render_not_found
    rescue_from ActionController::UnknownController, :with => :render_not_found
    rescue_from ActionController::UnknownAction,     :with => :render_not_found
  end

  clear_helpers

  protect_from_forgery
  before_filter :valid_locale?
  before_filter :set_locale
  before_filter :analyze_useragent
  before_filter :authenticate_user!, :except => [:render_error, :render_not_found, :in_development]
  before_filter :get_areas
  before_filter :setup_search

  layout :irekia_layout

  def valid_locale?
    raise ActionController::RoutingError, 'invalid locale' unless params[:locale].blank? || I18n.available_locales.include?(params[:locale].to_sym)
  end

  def set_locale
    user_locale    = current_user.locale if user_signed_in? && current_user.locale.present?
    params_locale  = params[:locale]
    cookie_locale  = cookies[:current_locale] || {}

    I18n.locale = params_locale || user_locale || cookie_locale || I18n.default_locale
  end

  def default_url_options(options = {})
    user_locale = current_user.locale if user_signed_in? && current_user.locale.present?
    cookie_locale  = cookies[:current_locale] || {}
    url_options = {:locale => user_locale || cookie_locale || I18n.locale}
    url_options[:datalogger] = true if request.params[:datalogger].present?
    url_options[:moderatorapp] = true if request.params[:moderatorapp].present?
    url_options
  end

  def analyze_useragent
    request.format = :iphone if datalogger_request? || moderatorapp_request?
  end

  def after_sign_in_path_for(resource)
    if request.xhr?
      session['user_return_to'] = nil
      nav_bar_buttons_path(request.params.slice(:datalogger))
    else
      return_to = session['unauthorized_url'] || session['user_return_to'] || root_path
      session['user_return_to'] = session['unauthorized_url'] = nil
      return_to.to_s
    end
  end

  def render_error(exception)
    logger.fatal '#################################################'
    logger.fatal exception
    exception.backtrace.each { |line| logger.fatal line }
    logger.fatal '#################################################'
    render :partial => 'shared/error', :status => 500
  end

  def render_not_found
    @areas_footer ||= Area.for_footer.all
    render :partial => 'shared/not_found', :status => 404
  end

  def in_development
    render :partial => 'shared/in_development'
  end

  def datalogger_request?
    request.params[:datalogger].present?
  end

  def moderatorapp_request?
    request.params[:moderatorapp].present?
  end

  def irekia_layout
    datalogger_request?? 'datalogger' : 'application'
  end
  private :irekia_layout

  def get_areas
    @areas = Area.names_and_ids.all
    @areas_footer = Area.for_footer.all
  end
  private :get_areas

  def setup_search
    @search = OpenStruct.new(params[:search])
  end
  private :setup_search

  def redirect_back_or_default(default)
    if session['user_return_to'].nil?
      redirect_to default
    else
      redirect_to session['user_return_to']
      session['user_return_to'] = nil
    end
  end
  private :redirect_back_or_default

  def redirect_back_or_render_action(action)
    if session['user_return_to'].nil?
      render action
    else
      redirect_to session['user_return_to']
      session['user_return_to'] = nil
    end
  end
  private :redirect_back_or_render_action
end
