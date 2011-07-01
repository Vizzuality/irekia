#encoding: UTF-8
require 'spec_helper'

describe 'Follow' do

  it "allows users to follow areas and other users" do
    area = create_area
    user1 = create_user
    user2 = create_user

    user1.areas_following << area
    user1.users_following << user2
    user1.save

    user2.areas_following << area
    user2.save

    user1.areas_following.should include(area)
    user1.users_following.should include(user2)

    user2.areas_following.should include(area)
    user2.followers.should include(user1)
  end

end