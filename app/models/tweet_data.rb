class TweetData < ActiveRecord::Base
  belongs_to :tweet

  def publish
    tweet.publish if tweet.present?
  end

end
