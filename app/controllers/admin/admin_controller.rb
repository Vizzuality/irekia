class Admin::AdminController < ApplicationController
  before_filter :admin_signed_in?

  layout 'administration'

  def index

  end

  def admin_signed_in?
    redirect_to root_url, :failure => 'Only administrators can access this section' unless current_user.administrator?
  end
  private :admin_signed_in?
end