#encoding: UTF-8

module CapybaraHelpers
  def peich
    save_and_open_page
  end

  def login_as_anonymous_user
    visit root_path

    click_link 'Login'

    within '#sign_in' do
      fill_in 'Email', :with => 'pepito@irekia.com'
      fill_in 'Contraseña', :with => 'irekia1234'

      click_button 'Entrar'
    end
  end
end
RSpec.configure {|config| config.include CapybaraHelpers}