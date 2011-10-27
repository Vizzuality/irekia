class FollowsController < ApplicationController
  before_filter :get_area
  before_filter :get_user

  layout false

  def new
    @follow = if @area then @area.follows.build else @user.follows.build end
    @followers_count = @follow_parent.followers.count
  end

  def create
    @follow = Follow.new params[:follow]
    @follow.user = current_user
    @follow.save!

    redirect_to edit_area_follow_path(@area, @follow) and return if @area
    redirect_to edit_user_follow_path(@user, @follow) and return if @user
  end

  def edit
    @follow = Follow.where(:id => params[:id]).first
  end

  def destroy
    @follow = Follow.where(:id => params[:id]).first
    @follow.destroy

    redirect_to new_area_follow_path(@area) and return if @area
    redirect_to new_user_follow_path(@user) and return if @user
  end

  def get_area
    @follow_parent = @area = Area.find(params[:area_id]) if params[:area_id]
  end
  private :get_area

  def get_user
    @follow_parent = @user = User.find(params[:user_id]) if params[:user_id]
  end
  private :get_user
end
