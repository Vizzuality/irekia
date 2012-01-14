class FollowsObserver < ActiveRecord::Observer
  observe :follow

  def after_create(follow)
    IrekiaMailer.new_follower(follow).deliver
  end
end
