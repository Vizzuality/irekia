class FollowsObserver < ActiveRecord::Observer
  observe :follow

  def after_create(follow)
    return if follow.follow_item.is_a?(Area) || follow.follow_item.skip_mailing

    IrekiaMailer.new_follower(follow).deliver
  end
end
