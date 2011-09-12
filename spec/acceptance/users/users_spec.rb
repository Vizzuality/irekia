#encoding: UTF-8

require 'spec_helper'

feature "Users" do
  before do
    user = User.create :name => 'José López Pérez', :email => 'pepito@irekia.com', :password => 'irekia1234', :password_confirmation => 'irekia1234'
    login_as_regular_user
  end

  scenario "has a layout common to all pages" do
    visit '/users/1' do
      within '.welcome' do
        page.should have_css 'h1', :text => "Hola de nuevo #{user.name},"
      end
    end
  end

end
