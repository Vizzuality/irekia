class UsersObserver < ActiveRecord::Observer
  observe :user

  def after_destroy(user)
    IrekiaMailer.deleted_account(user).deliver
  end
end
