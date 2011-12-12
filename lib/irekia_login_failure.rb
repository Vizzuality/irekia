class IrekiaLoginFailure < Devise::FailureApp
  def redirect_url
		session[:return_to] || root_path
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
