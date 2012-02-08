class Admin::AdminController < ApplicationController

  skip_before_filter :authenticate_user!
  before_filter :admin_signed_in?

  layout :admin_layout

  def index
  end

  def admin_signed_in?
    unless current_user.present? && current_user.administrator?
      redirect_to root_url, :failure => 'only administrators can access this section' and return if params[:moderatorapp].blank?
      redirect_to admin_path unless controller_name == 'admin' && action_name == 'index'
    end
  end
  private :admin_signed_in?

  def admin_layout
    params[:moderatorapp].present?? 'datalogger' : 'administration'
  end
  private :admin_layout

end
