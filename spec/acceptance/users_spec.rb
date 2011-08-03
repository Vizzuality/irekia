#encoding: UTF-8

require 'spec_helper'

feature "Users" do
  scenario "can sign-up in Irekia" do
    visit root_path
    click_link 'Regístrate'

    within '#sign_up' do
      fill_in 'Email', :with => 'pepito@irekia.com'
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

    visit root_path
    click_link 'Login'

    within '#sign_in' do
      fill_in 'Email', :with => 'pepito@irekia.com'
      fill_in 'Contraseña', :with => 'irekia1234'

      click_button 'Entrar'
    end

    page.should have_link 'Salir'
  end
end