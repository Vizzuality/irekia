class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      env['warden'].set_user(@user)

      redirect_back_or_default user_path(@user)
    else
      @user.save!
      env['warden'].set_user(@user)

      redirect_to edit_user_path(@user)
    end
  end

  def twitter
    @user = User.find_for_twitter_oauth(env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      env['warden'].set_user(@user)

      redirect_back_or_default user_path(@user)
    else

      @user.save!
      env['warden'].set_user(@user)

      redirect_to edit_user_path(@user)
    end
  end

end
