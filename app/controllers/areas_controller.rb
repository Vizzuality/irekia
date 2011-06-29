class AreasController < ApplicationController
  before_filter :get_area, :only => :show
  def show

  end

  private
  def get_area
    @area = Area.where(:id => params[:id]).first if params[:id].present?
  end
end