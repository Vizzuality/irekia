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
end
