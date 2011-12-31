class Users::PasswordsController < Devise::PasswordsController

  def after_sending_reset_password_instructions_path_for(resource_name)
    root_path
  end

end
