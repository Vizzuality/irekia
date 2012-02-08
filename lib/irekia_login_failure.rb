class IrekiaLoginFailure < Devise::FailureApp
  def redirect_url
    session['unauthorized_url'] = session['user_return_to']

    return admin_path(request.params.slice(:moderatorapp)) if request.params[:moderatorapp].present?

    root_path(request.params.slice(:datalogger))
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
