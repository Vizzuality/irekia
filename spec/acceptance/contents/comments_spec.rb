#encoding: UTF-8

require 'spec_helper'

feature "Contents' comments section" do
  background do
    init_contents_data
    @news = News.first
  end


  context 'being an anonymous user' do

    scenario "shows content's comments list" do
      visit news_path(@news)

      page.should have_css 'ul.comments li', :count => 2
      within '.comments li' do

        page.should have_content 'Me encantaría que realmente esta gente fuera siempre a los eventos y nos lo comunicaran como en esta ocasión. La verdad que fue un buen momento para hablar con ellos y conocerlos en persona.'
        page.should have_css 'img'
        page.should have_content 'María González Pérez hace menos de 1 minuto'
        page.should have_link 'María González Pérez'
      end
    end
  end

  context 'being a regular user' do
    background do
      login_as_regular_user
    end

    scenario "shows content's comments list and allows to post new comments" do
      visit news_path(@news)

      page.should have_css 'ul.comments li', :count => 3
      within '.comments li' do
peich
        page.should have_content 'Me encantaría que realmente esta gente fuera siempre a los eventos y nos lo comunicaran como en esta ocasión. La verdad que fue un buen momento para hablar con ellos y conocerlos en persona.'
        page.should have_css 'img'
        page.should have_content 'María González Pérez hace menos de 1 minuto'
        page.should have_link 'María González Pérez'
      end
      within '.comments li form' do
        fill_in '¿Algo que decir?... comenta esta noticia', :with => 'Prueba comentario'
        expect{ click_button 'Comentar'}.to change{ Comment.not_moderated.count }.by(1)
      end

    end

  end

end