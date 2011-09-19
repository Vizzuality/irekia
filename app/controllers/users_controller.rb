class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:intro, :new, :create, :show]
  before_filter :get_user, :only => [:show, :edit, :update, :connect]

  def show
    @activity = @user.actions + @user.followings_actions
  end

  def intro
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create params[:user]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      env['warden'].set_user(@user)
      redirect_to edit_user_path(@user)
    else
      render :new
    end
  end

  def edit
    session[:return_to] = connect_user_path(@user)
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = :question_created if params['user']['questions_attributes'].present?
    else
      flash[:notice] = :question_failed if params['user']['questions_attributes'].present?
    end

    redirect_back_or_default user_path(@user)
  end

  def connect
    session[:return_to] = connect_user_path(@user)
  end

  def get_user
    @user = User.where(:id => params[:id]).first if params[:id].present?
  end
  private :get_user
end
