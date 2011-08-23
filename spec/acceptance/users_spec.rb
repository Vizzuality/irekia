#encoding: UTF-8

require 'spec_helper'

feature "Users" do
  scenario "can sign-up in Irekia" do
    visit root_path
    click_link 'Regístrate'

    within '#sign_up' do
      fill_in 'Email', :with => 'juanito@irekia.com'
      fill_in 'Contraseña', :with => 'irekia1234'
      fill_in 'Confirmar contraseña', :with => 'irekia1234'
      fill_in 'Nombre y apellidos', :with => 'Jose López Pérez'
      check 'Accept User Conditions'

      expect{ click_button 'Crear mi cuenta'}.to change{ User.count }.by(1)
    end
  end

  scenario "can sign-in in Irekia" do
    user = User.create :name => 'José López Pérez',
                       :email => 'pepito@irekia.com',
                       :password => 'irekia1234',
                       :password_confirmation => 'irekia1234'

    login_as_regular_user

    page.should have_link 'Salir'
  end

  context 'with facebook account' do
    background do
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
        }
      }
    end

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
    background do
      OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[:twitter] = {
        "provider"  => "twitter",
        "uid"       => '12345',
        "user_info" => {
          "email" => "email@email.com",
          "first_name" => "John",
          "last_name"  => "Doe",
          "name"       => "John Doe"
          # any other attributes you want to stub out for testing
        }
      }
    end

    scenario "can sign-in in Irekia" do
      visit root_path

      click_link 'Login'

      within '#sign_in' do

        expect{ click_link 'twitter_signin' }.to change{ User.count }.by(1)

      end
      page.should have_link 'Salir'
    end
  end
end