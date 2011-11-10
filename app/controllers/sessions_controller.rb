class SessionsController < Devise::SessionsController
	skip_before_filter :current_user_valid?
end
