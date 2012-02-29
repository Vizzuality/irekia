#encoding: UTF-8
module CapybaraHelpers
  def peich
    save_and_open_page
  end

  def sign_in_as(email, password)
    visit root_path

    click_on 'Accede a tu cuenta'

    fill_in 'Email', :with => email
    fill_in 'Contraseña', :with => password

    click_on 'Entra'

  end
end
RSpec.configure {|config| config.include CapybaraHelpers}
