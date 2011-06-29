#encoding: UTF-8
require 'spec_helper'

feature "Areas newsfeed" do
  background do
    @area = init_area_data
  end

  scenario "Browsing areas' newsfeed" do
    visit area_path(@area)

    within '#area_summary' do
      page.should have_css('h1', :text => 'Educación, Universidades e Investigación')
      within '.description' do
        page.should have_css('h3', :text => 'Qué hacemos')
        page.should have_css('p', :text => lorem)
      end
      within '.team' do
        page.should have_css('h3', :text => 'Equipo principal')
      end
    end
  end
end