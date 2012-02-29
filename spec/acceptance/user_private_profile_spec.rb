#encoding: UTF-8
require 'spec_helper'

feature 'User private profile' do
  scenario 'should have a dashboard' do
    sign_in_as 'pagocero@hotmail.com', 'patricia1234'

    page.should have_content 'Hola, Patricia.'

    visit root_path

    page.should have_css '#main .article.welcome.welcome-slideshow'
    page.should have_content 'Sigue lo que te interese'

    within 'div#main.users div.content ul.menu' do
      page.should have_link 'Resumen'
      page.should have_link 'Tus preguntas'
      page.should have_link 'Tus propuestas'
      page.should have_link 'Tu actividad'
      page.should have_link 'Siguiendo'
      page.should have_link 'Publicar'
    end

    within 'div#actions-.article' do
      page.should have_css 'div.inner div.left div.listing ul li.clearfix', :length => 6
    end

    within '.suggestions' do
      page.should have_css 'a.name',                    :length => 6
      page.should have_css 'button', :text => 'Seguir', :length => 6
    end
  end

  scenario 'should have a questions section' do
    sign_in_as 'pagocero@hotmail.com', 'patricia1234'

    page.should have_content 'Hola, Patricia.'

    visit root_path

    click_on 'Tus preguntas'

    within 'div#questions.article' do
      page.should have_content '1 pregunta contestada'
      page.should have_css 'div.inner div.left div.listing ul li.clearfix'

      page.should have_link 'Más recientes'
      page.should have_link 'Más debatidas'

      page.should have_link 'Todas'
      page.should have_link 'Contestadas'

    end
  end

  scenario 'should have a proposals section' do
    sign_in_as 'pagocero@hotmail.com', 'patricia1234'

    page.should have_content 'Hola, Patricia.'

    visit root_path

    click_on 'Tus propuestas'

    within 'div#proposals.article' do
      page.should have_content 'No has hecho ninguna propuesta'
      page.should have_css 'div.inner div.left div.listing ul li.clearfix'

      page.should have_link 'Más recientes'
      page.should have_link 'Más comentadas'

      page.should have_link 'Todas'
      page.should have_link 'Propuestas creadas por ti'

      page.should have_link 'Crea una propuesta'

    end
  end

  scenario 'should have an user activity section' do
    sign_in_as 'pagocero@hotmail.com', 'patricia1234'

    page.should have_content 'Hola, Patricia.'

    visit root_path

    click_on 'Tu actividad'

    within 'div#actions-patricia-gomez-pecero.article' do
      page.should have_content 'Tus últimas acciones'
      page.should have_css 'div.inner div.left div.listing ul li.clearfix', :length => 11

      page.should have_link 'Más recientes'
      page.should have_link 'Más debatidas'

      page.should have_link 'Todos los tipos'
      page.should have_content 'Noticias'
      page.should have_content 'Preguntas'
      page.should have_content 'Propuestas'
      page.should have_content 'Fotos'
      page.should have_content 'Vídeos'
      page.should have_content 'Cambios de estado'

    end
  end

  scenario 'should have a followings section' do

    sign_in_as 'pagocero@hotmail.com', 'patricia1234'

    page.should have_content 'Hola, Patricia.'

    visit root_path

    click_on 'Siguiendo'

    within 'div#main.users div.content div.article.with_footer' do
      page.should have_content 'A quién sigues en Irekia.'
      page.should have_css 'ul.suggestions li.selected', :length => 12
      page.should have_css 'hr'

    end
  end

end
