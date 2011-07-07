class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:show]
  before_filter :get_user, :only => [:show, :update]

  def show
  end

  def update

    if @user.update_attributes(params[:user])
      flash[:notice] = :question_created if params['user']['questions_attributes'].present?
    else
      flash[:notice] = :question_failed if params['user']['questions_attributes'].present?
    end

    redirect_back_or_default user_path(@user)
  end

  def get_user
    @user = User.where(:id => params[:id]).first if params[:id].present?
  end
  private :get_user
end