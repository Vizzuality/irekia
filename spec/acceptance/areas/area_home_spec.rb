#encoding: UTF-8

require 'spec_helper'

feature "Area's home" do

  background do
    @area = get_area_data
  end

  scenario "shows a summary of that area's politicians, actions and generated contents" do

    visit area_path(@area)

    within '.summary' do
      page.should have_css 'h1', :text => 'Educación, Universidades e Investigación'
      page.should have_css 'a.ribbon'
      page.should have_css 'h3', :text => 'Qué hacemos'
      page.should have_css 'p',  :text => String.lorem
      page.should have_button 'Seguir a este área (1)'

      within 'ul.people' do
        page.should have_css 'li a',    :text => 'Virginia Uriarte Rodríguez'
        page.should have_css 'li span', :text => 'Consejera'
        page.should have_css 'li a',    :text => 'Alberto de Zárate López'
        page.should have_css 'li span', :text => 'Vice-consejero'
      end

     # within '.status' do
     #   page.should have_css 'ul li.area span',      :text => '148 acciones esta semana'
     #   page.should have_css 'ul li.area a',         :text => 'Sigue a este área'
     #   page.should have_css 'ul li.questions span', :text => '1 pregunta contestada'
     #   page.should have_css 'ul li.questions a',    :text => 'Haz una pregunta'
     #   page.should have_css 'ul li.proposals span', :text => '1 propuesta abierta'
     #   page.should have_css 'ul li.proposals a',    :text => 'Lanza tu propuesta'
     # end
    end
  end

  scenario 'can be followed by a registered user' do
    login_as_regular_user

    visit area_path(@area)

    expect{ click_button 'Seguir a este área (1)' }.to change{ @area.followers.count }.by(1)

    page.should_not have_button 'Seguir a este área (2)'
    page.should have_button 'Dejar de seguir'

    expect{ click_button 'Dejar de seguir' }.to change{ @area.followers.count }.by(-1)

    page.should_not have_button 'Dejar de seguir'

    click_button 'Seguir a este área (1)'

    visit area_path(@area)

    page.should_not have_button 'Seguir a este área (1)'
    page.should_not have_button 'Seguir a este área (2)'

    page.should have_button 'Dejar de seguir'
  end

  scenario 'shows a list of last actions related to that area' do

    visit area_path(@area)

    within '.actions' do
      page.should have_css 'h2', :text => 'Últimas acciones'

      page.should have_css 'a.filter.recent', :text => 'Más recientes'
      page.should have_css 'a.filter.polemic', :text => 'Más polémicas'

      within '.argument' do
        page.should have_css 'p', :text => 'A favor de la propuesta "Actualizar la información publicada sobre las ayudas a familias numerosas"'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'Aritz Aranburu participó hace menos de 1 minuto'
        page.should have_css '.footer span.published_at a', :text => 'Aritz Aranburu'
        page.should have_css '.footer a', :text => 'Ningún comentario'
        page.should have_css '.footer a', :text => 'Compartir'
      end

      within '.answer' do
        page.should have_css 'p', :text => 'Contestando a "Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'
        page.should have_css 'p.excerpt', :text => '"Hola María, en realidad no va a haber ayuda este año. El recorte este"'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'Virginia Uriarte Rodríguez contesto hace menos de 1 minuto'
        page.should have_css '.footer span.published_at a', :text => 'Virginia Uriarte Rodríguez'
        page.should have_css '.footer a', :text => '1 comentario'
        page.should have_css '.footer a', :text => 'Compartir'
      end

      within '.news' do
        page.should have_css 'p', :text => 'Inauguración del nuevo complejo deportivo en la localidad de Getxo'
        page.should have_css 'p.excerpt', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed d...'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'Publicado hace menos de 1 minuto'
        page.should have_css '.footer a', :text => '2 comentarios'
        page.should have_css '.footer a', :text => 'Compartir'
      end

      within '.question' do
        page.should have_css 'p', :text => 'Pregunta para el área...'
        page.should have_css 'p.excerpt', :text => '"Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css '.footer span.published_at a', :text => 'María González Pérez'
        page.should have_css '.footer a', :text => 'Ningún comentario'
        page.should have_css '.footer a', :text => 'Compartir'
      end

      within '.right .selector' do
        page.should have_link 'Todos los tipos'
        page.should have_link 'Noticias'
        page.should have_link 'Actividad de los políticos'
        page.should have_link 'Preguntas'
        page.should have_link 'Propuestas'
        page.should have_link 'Fotos'
        page.should have_link 'Vídeos'
      end

      page.should have_css 'footer .right a', :text => 'ver más acciones'
    end

    within 'article.actions' do
      click_link 'Noticias'
    end

    page.should have_css 'article#actions div#listing ul li.news', :count => 1

    within 'article.actions' do
      click_link 'Preguntas'
    end

    page.should have_css 'article#actions div#listing ul li.question', :count => 2

 end

  scenario "shows the list of questions made to that area" do

    visit area_path(@area)

    within '.questions' do
      page.should have_css 'h2', :text => 'Preguntas de los ciudadanos'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within '.question' do
        #page.should have_css 'p', :text => 'Pregunta para Virginia Uriarte Rodríguez...'
        page.should have_css 'p.excerpt', :text => '"¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?"'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css '.footer span.published_at a', :text => 'María González Pérez'
        page.should have_css '.footer span.not_answered', :text => 'Aún no contestada'
        page.should have_css '.footer a', :text => '1 comentario'
      end

      within '.question:last-child' do
        page.should have_css 'p', :text => 'Pregunta para el área...'
        page.should have_css 'p.excerpt', :text => '"Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css '.footer span.published_at a', :text => 'María González Pérez'
        page.should have_css '.footer span.published_at span.answered', :text => 'Contestada hace menos de 1 minuto'
        page.should have_css '.footer a.comment-count', :text => 'Ningún comentario'
      end

      within 'ul.selector' do
        page.should have_link 'Todas'
        page.should have_link 'Contestadas'
      end
      page.should have_link 'Haz una pregunta'

      page.should have_css 'footer .inner .right a', :text => 'ver más preguntas'
    end
  end

  scenario "shows the list of proposals sent to that area" do

    visit area_path(@area)

    within '.proposals' do
      page.should have_css 'h2', :text => 'Propuestas'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.proposal' do
        page.should have_css 'p', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'

        within '.graphs' do
          page.should have_css '.sparkline.positive .legend'#, :text => '66 a favor'
          page.should have_css '.sparkline.negative .legend'#, :text => '57 en contra'
        end

        page.should have_css 'img'
        page.should have_css '.footer span.author', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css '.footer span.author a', :text => 'María González Pérez'
        page.should have_css '.footer a.participants-count', :text => '123 usuarios han participado'
      end

      within '.selector' do
        page.should have_link 'Todas'
        page.should have_link 'Propuestas del gobierno'
        page.should have_link 'Propuestas ciudadanas'
      end
      page.should have_link 'Crea una propuesta'

      page.should have_css 'footer .inner .right a', :text => 'ver más propuestas'
    end
  end

  scenario "shows that area's agenda" do

    visit area_path(@area)

    within '.agenda' do
      page.should have_css 'h2', :text => 'Agenda del área'

      page.should have_css 'a.view_calendar', :text => 'Ver calendario'
      page.should have_css 'a.view_map', :text => 'Ver mapa'

      within '.content' do
        (1..14).each do |n|
          page.should have_css '.day h3', :text => n.to_s
          page.should have_css '.month', :text => 'ago'
          page.should have_no_css '.detail'
        end

       # TODO enable theses tests:
       # page.should have_css 'li.ago_02 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 3
       # page.should have_css 'li.ago_03 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
       # page.should have_css 'li.ago_04 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 3
       # page.should have_css 'li.ago_10 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 3
       # page.should have_css 'li.ago_11 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
       # page.should have_css 'li.ago_12 div.title', :text => 'Reunión con el Sindicato de Estudiantes Universitarios'
      end

      page.should have_css 'footer .right a', :text => 'Ver calendario completo'
    end
  end

end
