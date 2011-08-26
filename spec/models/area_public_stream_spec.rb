#encoding: UTF-8
require 'spec_helper'

describe 'Area Public Stream' do

  it "stores new contents published in a determined area" do
    area = Area.find_or_create_by_name('Test area')

    user1 = User.find_or_initialize_by_name_and_email('User1', 'user1@example.com')
    user1.password = 'example'
    user1.password_confirmation = 'example'
    user1.save!

    user2 = User.find_or_initialize_by_name_and_email('User2', 'user2@example.com')
    user2.password = 'example'
    user2.password_confirmation = 'example'
    user2.save!

    user3 = User.find_or_initialize_by_name_and_email('User3', 'user3@example.com')
    user3.password = 'example'
    user3.password_confirmation = 'example'
    user3.save!

    content = Content.create :users    => [user1],
                             :areas    => [area],
                             :comments => [user2.comments.new.create_with_body(String.lorem)]

    expect{content.update_attribute('moderated', true)}.to change{AreaPublicStream.count}.by(1)

    area_public_stream = AreaPublicStream.last

    content_json = JSON.parse area_public_stream.message
    content_json.should be == {
      'author'          => {
        'id'            => user1.id,
        'name'          => 'User1',
        'profile_image' => nil
      },
      'published_at'    => '2011-08-03T10:00:00Z',
      'comments' => 1
    }

    content.comments << user3.comments.new.create_with_body(String.lorem)
    expect do
      content.save!
    end.to change{AreaPublicStream.count}.by(0)

    area_public_stream.reload

    content_json = JSON.parse area_public_stream.message
    content_json.should be == {
      'author'          => {
        'id'            => user1.id,
        'name'          => 'User1',
        'profile_image' => nil
      },
      'published_at'    => '2011-08-03T10:00:00Z',
      'comments' => 2
    }
  end

end