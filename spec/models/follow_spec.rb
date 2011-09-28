#encoding: UTF-8
require 'spec_helper'

describe 'Follow' do

  it "allows users to follow areas and other users" do
    area = Area.find_or_create_by_name('Educación, Universidades e Investigación', :description => String.lorem)

    area.followers.should have(1).user

    user1 = User.find_or_initialize_by_name_and_email('User1', 'user1@example.com')
    user1.password = 'example'
    user1.password_confirmation = 'example'
    user1.save!

    user2 = User.find_or_initialize_by_name_and_email('User2', 'user2@example.com')
    user2.password = 'example'
    user2.password_confirmation = 'example'
    user2.save!

    user1.areas_following << area
    user1.users_following << user2
    user1.save

    user2.areas_following << area
    user2.save

    user1.areas_following.should include(area)
    user1.users_following.should include(user2)

    user2.areas_following.should include(area)
    user2.followers.should include(user1)

    user3 = User.find_or_initialize_by_name_and_email('User3', 'user3@example.com')
    user3.password = 'example'
    user3.password_confirmation = 'example'
    user3.save!

    area.followers << user3
    area.save!

    area.followers.reload.should have(4).users
    user3.areas_following.should have(1).area
  end

end
