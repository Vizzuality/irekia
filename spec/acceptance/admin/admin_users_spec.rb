#encoding: UTF-8

require 'spec_helper'

feature "Users admin page" do
  background do
    login_as_administrator
  end

  scenario "shows a list of registered users" do
    visit admin_users_path

    within '#users' do
      page.should have_link 'Nuevo usuario'
      page.should have_css 'li.user', :count => 10

      within 'li.user' do
        page.should have_link 'Administrator'
        page.should have_link 'Editar usuario'
        page.should have_link 'Eliminar usuario'
      end
    end
  end

  scenario "allows to create a new user" do
    visit admin_users_path

    click_link 'Nuevo usuario'
peich
    fill_in 'Nombre y apellidos',   :with => 'Fernando Espinosa Jiménez'
    fill_in 'Email',                :with => 'ferdev@vizzuality.com'
    fill_in 'Contraseña',           :with => 'wadus1234'
    fill_in 'Confirmar contraseña', :with => 'wadus1234'
    select 'Político',                                 :from => 'Rol'
    select 'Consejero/Consejera',                      :from => 'Título'
    select 'Educación, Universidades e Investigación', :from => 'Área'
    attach_file 'Imagen', Rails.root.join('db', 'seeds', 'test_data', 'images', 'man.jpeg')

    expect{ click_button 'Crear usuario'}.to change{ User.count }.by(1)

    visit admin_users_path

    page.should have_css '#users li.user', :count => 11

  end

  scenario "allows to edit an existing user" do
    visit admin_users_path

    click_link 'Alberto de Zárate López'

    fill_in 'Nombre y apellidos',   :with => 'Alberto López de Zárate'

    click_button 'Editar usuario'

    visit admin_users_path

    within '#users' do
      page.should have_link 'Alberto López de Zárate'
    end

  end

  scenario "allows to delete an existing user" do
    visit admin_users_path

    within '#users li.user:last-child' do
      expect{ click_link 'Eliminar usuario'}.to change{ User.count }.by(-1)
    end

    visit admin_users_path

    page.should have_css '#users li.user', :count => 9
  end

end