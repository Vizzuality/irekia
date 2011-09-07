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
    scenario "can sign-up in Irekia" do
      visit root_path
      click_link 'Regístrate'

      page.should have_content '¿Nuevo en Irekia?'
      page.should have_content 'Utiliza Facebook o Twitter para registrarte.'

      page.should have_link 'Conectar con Facebook'
      page.should have_link 'Conectar con Twitter'

      click_link '¿No tienes cuenta de Facebook ni de Twitter?'

      within '#sign_up' do
        fill_in 'Email', :with => 'email@email.com'
        fill_in 'Contraseña', :with => 'irekia1234'
        fill_in 'Repetir contraseña', :with => 'irekia1234'
        check 'Acepto las condiciones de uso'
        page.should have_link 'condiciones de uso'

        expect{ click_button 'Continuar'}.to change{ User.count }.by(1)
        
        @user = User.last
      end

      page.should have_content 'Cuéntanos más de tí.'
      page.should have_content 'Queremos conocerte mejor.'

      within 'form.edit_user' do
        fill_in 'Nombre', :with => 'John'
        fill_in 'Apellidos', :with => 'Doe'
        select 'Vizcaya', :from => 'Territorio'
        select 'Bilbao', :from => 'Municipio'
        select '23', :from => 'user_birthday_3i'
        select 'septiembre', :from => 'user_birthday_2i'
        select '1988', :from => 'user_birthday_1i'

        page.should have_link '¿Qué vamos a hacer con estos datos?'

        click_button 'Continuar'
      end

      page.should have_content 'Conéctate.'
      page.should have_content 'Irekia funciona mucho mejor conectándola con tus redes sociales.'
      page.should have_link 'Descubre por qué queremos que te conectes.'

      click_link 'Conectar con Facebook'
      
      @user.reload.facebook_oauth_token.should be == 'FFFFFFFFFFFFFFF'
      @user.reload.facebook_oauth_token_secret.should be == 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
      
      page.should_not have_link 'Conectar con Facebook'
      page.should have_content 'Conectar con Facebook'

      click_link 'Conectar con Twitter'

      @user.reload.twitter_oauth_token.should be == 'TTTTTTTTTTTTTTTTTTTTT'
      @user.reload.twitter_oauth_token_secret.should be == 'TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT'

      page.should_not have_link 'Conectar con Twitter'
      page.should have_content 'Conectar con Twitter'

      click_link 'Continuar'

      current_path.should be == user_path(@user)

    end

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
    
    scenario "can sign-up in Irekia" do
      visit root_path
      click_link 'Regístrate'

      page.should have_content '¿Nuevo en Irekia?'
      page.should have_content 'Utiliza Facebook o Twitter para registrarte.'

      page.should have_link 'Conectar con Facebook'
      page.should have_link 'Conectar con Twitter'

      click_link 'Conectar con Facebook'

      @user = User.last
      @user.facebook_oauth_token.should be == 'FFFFFFFFFFFFFFF'
      @user.facebook_oauth_token_secret.should be == 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'

      page.should have_content 'Cuéntanos más de tí.'
      page.should have_content 'Queremos conocerte mejor.'

      within 'form.edit_user' do
        fill_in 'Nombre', :with => 'John'
        fill_in 'Apellidos', :with => 'Doe'
        select 'Vizcaya', :from => 'Territorio'
        select 'Bilbao', :from => 'Municipio'
        select '23', :from => 'user_birthday_3i'
        select 'septiembre', :from => 'user_birthday_2i'
        select '1988', :from => 'user_birthday_1i'

        page.should have_link '¿Qué vamos a hacer con estos datos?'

        click_button 'Continuar'
      end

      page.should have_content 'Conéctate.'
      page.should have_content 'Irekia funciona mucho mejor conectándola con tus redes sociales.'
      page.should have_link 'Descubre por qué queremos que te conectes.'

      page.should_not have_link 'Conectar con Facebook'
      page.should have_content 'Conectar con Facebook'

      click_link 'Conectar con Twitter'

      @user.reload.twitter_oauth_token.should be == 'TTTTTTTTTTTTTTTTTTTTT'
      @user.reload.twitter_oauth_token_secret.should be == 'TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT'

      page.should_not have_link 'Conectar con Twitter'
      page.should have_content 'Conectar con Twitter'

      click_link 'Continuar'

      current_path.should be == user_path(@user)

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

    scenario "can sign-up in Irekia" do
      visit root_path
      click_link 'Regístrate'

      page.should have_content '¿Nuevo en Irekia?'
      page.should have_content 'Utiliza Facebook o Twitter para registrarte.'

      page.should have_link 'Conectar con Facebook'
      page.should have_link 'Conectar con Twitter'

      click_link 'Conectar con Twitter'

      @user = User.last
      @user.reload.twitter_oauth_token.should be == 'TTTTTTTTTTTTTTTTTTTTT'
      @user.reload.twitter_oauth_token_secret.should be == 'TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT'

      page.should have_content 'Cuéntanos más de tí.'
      page.should have_content 'Queremos conocerte mejor.'

      within 'form.edit_user' do
        fill_in 'Nombre', :with => 'John'
        fill_in 'Apellidos', :with => 'Doe'
        select 'Vizcaya', :from => 'Territorio'
        select 'Bilbao', :from => 'Municipio'
        select '23', :from => 'user_birthday_3i'
        select 'septiembre', :from => 'user_birthday_2i'
        select '1988', :from => 'user_birthday_1i'

        page.should have_link '¿Qué vamos a hacer con estos datos?'

        click_button 'Continuar'
      end

      page.should have_content 'Conéctate.'
      page.should have_content 'Irekia funciona mucho mejor conectándola con tus redes sociales.'
      page.should have_link 'Descubre por qué queremos que te conectes.'

      page.should_not have_link 'Conectar con Twitter'
      page.should have_content 'Conectar con Twitter'

      click_link 'Conectar con Facebook'

      @user.reload.facebook_oauth_token.should be == 'FFFFFFFFFFFFFFF'
      @user.reload.facebook_oauth_token_secret.should be == 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'

      page.should_not have_link 'Conectar con Twitter'
      page.should have_content 'Conectar con Twitter'

      click_link 'Continuar'

      current_path.should be == user_path(@user)

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

  context 'being logged in' do
    background do
      login_as_regular_user
    end

    scenario "can sing-out whenever he wants" do
      visit root_path

      within '#navigation' do
        page.should_not have_link 'Regístrate'
        page.should_not have_link 'Login'
      end

      click_link 'Salir'

      within '#navigation' do
        page.should have_link 'Regístrate'
        page.should have_link 'Login'
      end

    end
  end
end