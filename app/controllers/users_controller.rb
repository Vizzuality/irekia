class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:show]
  before_filter :get_user, :only => [:show, :update]

  def show
  end

  def update
    @user.update_attributes(params[:user])

    redirect_to user_path(@user)
  end

  def get_user
    @user = User.where(:id => params[:id]).first if params[:id].present?
  end
  private :get_user
end