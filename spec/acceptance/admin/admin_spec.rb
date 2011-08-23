#encoding: UTF-8

require 'spec_helper'

feature "Admin section" do

  context 'as an administrator' do
    background do
      login_as_administrator
    end

    scenario "grants access to all its sections" do
      visit admin_path

      current_path.should == admin_path
    end

    scenario "has a navigation menu common to all sections" do
      visit admin_path

      within '.navigation' do
        page.should have_link 'Administrar usuarios'
        page.should have_link 'Moderar contenidos'
      end
    end

  end

  context 'as a regular user' do
    background do
      login_as_regular_user
    end

    scenario "does not grant access to any of its sections" do
      visit admin_path

      current_path.should == root_path
    end
  end

end