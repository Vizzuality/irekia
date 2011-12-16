class IrekiaLoginFailure < Devise::FailureApp
  def redirect_url
		@redirect_url = session[:return_to] || root_path
    session[:return_to] = nil
    @redirect_url
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
