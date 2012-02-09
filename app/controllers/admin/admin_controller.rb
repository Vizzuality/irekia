class Admin::AdminController < ApplicationController

  skip_before_filter :authenticate_user!
  before_filter :set_iphone_format
  before_filter :store_get_url
  before_filter :admin_signed_in?

  layout :admin_layout

  def index
  end

  def set_iphone_format
    request.format = :iphone if moderatorapp_request? && admin_login?
  end
  private :set_iphone_format

  def store_get_url
    return if admin_login?
    session['user_return_to'] = request.fullpath if request.get?
  end

  def admin_signed_in?
    unless current_user.present? && current_user.administrator?
      redirect_to root_url, :failure => 'only administrators can access this section' and return if params[:moderatorapp].blank?
      redirect_to admin_path unless admin_login?
    end
  end
  private :admin_signed_in?

  def admin_layout
    params[:moderatorapp].present? && admin_login? ? 'datalogger' : 'administration'
  end
  private :admin_layout

  def admin_login?
    controller_name == 'admin' && action_name == 'index'
  end
  private :admin_login?

end
