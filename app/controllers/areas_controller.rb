class AreasController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:index, :show]
  before_filter :get_area, :only => :show

  def show
    @team = @area.team
  end

  private
  def get_area
    @area = Area.where(:id => params[:id]).first if params[:id].present?
  end
end