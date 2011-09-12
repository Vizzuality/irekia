#encoding: UTF-8

require 'spec_helper'

feature "Users" do
  before do

    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:facebook] = {
      "provider"  => "facebook",
      "uid"       => '12345',
      "user_info" => {
        "email" => "email@email.com",
        "first_name" => "John",
        "last_name"  => "Doe",
        "name"       => "John Doe"
        # any other attributes you want to stub out for testing
      },
      "credentials" => {
        "token"  => 'FFFFFFFFFFFFFFF',
        "secret" => 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
      }
    }

    OmniAuth.config.mock_auth[:twitter] = {
      "provider"  => "twitter",
      "uid"       => '12345',
      "user_info" => {
        "email" => "email@email.com",
        "first_name" => "John",
        "last_name"  => "Doe",
        "name"       => "John Doe"
        # any other attributes you want to stub out for testing
      },
      "credentials" => {
        "token"  => 'TTTTTTTTTTTTTTTTTTTTT',
        "secret" => 'TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT'
      }
    }

  end

  context 'without facebook and twitter accounts' do

    scenario "can sign-in in Irekia" do
      user = User.create :name => 'José López Pérez',
                         :email => 'pepito@irekia.com',
                         :password => 'irekia1234',
                         :password_confirmation => 'irekia1234'

      login_as_regular_user

      page.should have_link 'Salir'
    end

  end

  context 'with facebook account' do

    scenario "can sign-in in Irekia" do
      visit root_path

      click_link 'Login'

      within '#sign_in' do

        expect{ click_link 'facebook_signin' }.to change{ User.count }.by(1)

      end
      page.should have_link 'Salir'
    end

  end

  context 'with twitter account' do

    scenario "can sign-in in Irekia" do
      visit root_path

      click_link 'Login'

      within '#sign_in' do

        expect{ click_link 'twitter_signin' }.to change{ User.count }.by(1)

      end
      page.should have_link 'Salir'
    end

  end

  context 'being logged in' do
    background do
      login_as_regular_user
    end

    scenario "can sing-out whenever he wants" do
      visit root_path

      within 'nav' do
        page.should_not have_link 'Regístrate'
        page.should_not have_link 'Login'
      end

      click_link 'Salir'

      within 'nav' do
        page.should have_link 'Regístrate'
        page.should have_link 'Login'
      end

    end
  end
end
