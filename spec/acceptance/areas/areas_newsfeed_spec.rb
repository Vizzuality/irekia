#encoding: UTF-8
require 'spec_helper'

feature "Areas newsfeed" do
  background do
    init_area_data
  end

  scenario "Browsing areas' newsfeed" do
    visit areas_path
  end
end