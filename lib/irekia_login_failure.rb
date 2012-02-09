class IrekiaLoginFailure < Devise::FailureApp
  def redirect_url
    session['unauthorized_url'] = session['user_return_to']

    root_path(request.params.slice(:datalogger, :moderatorapp))
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
