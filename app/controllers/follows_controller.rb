class FollowsController < ApplicationController
  before_filter :get_area
  before_filter :get_user
  before_filter :get_form_types, :only => [:new, :edit]

  layout false

  def new
    @follow = if @area then @area.follows.build else @user.follows.build end
    @followers_count = @follow_parent.followers.count
  end

  def create
    @follow = Follow.new params[:follow]
    @follow.user = current_user
    @follow.save!

    form_types = [params[:form_type]]
    form_types = ['', 'ribbon'] if params[:form_type].blank? || params[:form_type] == 'ribbon'

    redirect_to edit_area_follow_path(@area, @follow, :form_types => form_types) and return if @area
    redirect_to edit_user_follow_path(@user, @follow, :form_types => form_types) and return if @user
  end

  def edit
    @follow = Follow.where(:id => params[:id]).first

  end

  def destroy
    @follow = Follow.where(:id => params[:id]).first
    @follow.destroy

    form_types = [params[:form_type]]
    form_types = ['', 'ribbon'] if params[:form_type].blank? || params[:form_type] == 'ribbon'

    redirect_to new_area_follow_path(@area, :form_types => form_types) and return if @area
    redirect_to new_user_follow_path(@user, :form_types => form_types) and return if @user
  end

  def button
    if current_user && (@follow = current_user.followed_item(@area || @user))
      redirect_to edit_area_follow_path(@area, @follow, :form_types => [params[:form_type]]) and return if @area
      redirect_to edit_user_follow_path(@user, @follow, :form_types => [params[:form_type]]) and return if @user
    else
      redirect_to new_area_follow_path(@area, :form_types => [params[:form_type]]) and return if @area
      redirect_to new_user_follow_path(@user, :form_types => [params[:form_type]]) and return if @user
    end
  end

  def get_area
    @follow_parent = @area = Area.find(params[:area_id]) if params[:area_id]
  end
  private :get_area

  def get_user
    @follow_parent = @user = User.find(params[:user_id]) if params[:user_id]
  end
  private :get_user

  def get_form_types
    @form_types = params[:form_types] || []
  end
  private :get_form_types
end
