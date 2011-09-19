#encoding: UTF-8

module CapybaraHelpers
  def peich
    save_and_open_page
  end

  def login_as(user)
     visit root_path

    click_link 'Login'

    within '#sign_in' do
      fill_in 'Email', :with => user[:email]
      fill_in 'Contraseña', :with => user[:password]

      click_button 'Entrar'
    end
 end

  def login_as_regular_user
    login_as :email => 'pepito@irekia.com', :password => 'irekia1234'
  end

  def login_as_administrator
    visit root_path

    click_link 'Login'

    within '#sign_in' do
      fill_in 'Email', :with => 'admin@example.com'
      fill_in 'Contraseña', :with => 'example'

      click_button 'Entrar'
    end
  end

  def regular_user
    @user ||= User.find_by_email('pepito@irekia.com')
  end
end
RSpec.configure {|config| config.include CapybaraHelpers}
