class FollowsObserver < ActiveRecord::Observer
  observe :follow

  def after_create(follow)
    IrekiaMailer.new_follower(follow).deliver if follow.follow_item.is_a?(User)
  end
end
