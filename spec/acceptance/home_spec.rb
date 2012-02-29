#encoding: UTF-8
require 'spec_helper'

feature 'Home page' do
  context 'as unregistered user'
    scenario 'should show homepage' do
      visit root_path

      page.should have_content 'Participa en tu gobierno.'
      page.should have_content 'Irekia es la plataforma que te permite hacer oir tu voz en la toma de decisiones de Euskadi. Haz tus propuestas, reclama respuestas, contribuye y opina.'

      within 'div#areas.article div.areas_list' do
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Lehendakaritza'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Interior'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Economía y Hacienda'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Educación, Universidades e Investigación'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Justicia y Administración Pública'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Vivienda, Obras Públicas y Transportes'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Industria, Innovación, Comercio y Turismo'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Empleo y Asuntos Sociales'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Sanidad y Consumo'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Medio Ambiente, Planificación Territorial, Agricultura y Pesca'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Cultura'
        page.should have_css 'ul li.clearfix div.info h3 a', :text => 'Gobierno Abierto'
      end

      within 'div#main.home div.content div.article.stats' do
        page.should have_content '5 ciudadanos'
        page.should have_content '191 políticos'
        page.should have_content '0 preguntas'
        page.should have_content '0 respondidas'
        page.should have_content '1 propuestas'
        page.should have_content '12 votos'
      end

      within 'div#main.home div.content div.home_last_activity' do
        page.should have_content 'Últimas acciones'
        page.should have_css 'div#actions-.article div.inner div.left div.listing ul li.clearfix', :length => 20
        page.should have_css 'div#actions-.article div.inner div.left div.listing ul li.clearfix', :length => 10, :visible => true

        within 'div#actions-.article div.inner div.right ul.selector' do
          page.should have_link    'Todos los tipos'
          page.should have_link    'Noticias'
          page.should have_content 'Preguntas'
          page.should have_link    'Propuestas'
          page.should have_link    'Fotos'
          page.should have_content 'Vídeos'
          page.should have_content 'Cambios de estado'
        end
      end

    end

    scenario 'should allow sign in' do
      sign_in_as 'pagocero@hotmail.com', 'patricia1234'

      page.should have_content 'Hola, Patricia.'
    end

    scenario 'should allow sign up' do
      visit root_path

      click_on 'Regístrate ya'

      click_on '¿No tienes cuenta de Facebook ni de Twitter?'

      fill_in 'Email',                      :with => 'test+1@irekia.com'
      fill_in 'user_password',              :with => 'prueba1234'
      fill_in 'user_password_confirmation', :with => 'prueba1234'
      check 'user_terms_of_service'

      within '.step1' do
        click_on 'Continuar'
      end

      fill_in 'Nombre',    :with => 'Pedro'
      fill_in 'Apellidos', :with => 'Serrano Serrano'

      #within '.step2' do
        #click_on 'Continuar'
      #end

      #page.should have_content 'Hola, José.'
    end

  context 'as signed in user' do

    scenario 'should show private profile page as home page' do
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

  end

end

