#encoding: UTF-8

require 'spec_helper'

feature "Politic's home" do

  background do
    @politic = init_politic_data
  end

  scenario "shows a summary with that politic's description, actions and questions answered" do

    visit politic_path(@politic)

    within '#politic_summary' do
      page.should have_css 'h1', :text => 'Virginia Uriarte Rodríguez'
      page.should have_css '.title', :text => 'Consejera de Educación, Universidades e Investigación'
      page.should have_link 'Educación, Universidades e Investigación'
      page.should have_css '.picture img'

      within '.description' do
        page.should have_css 'h3', :text => 'Quién es y qué hace'
        page.should have_css 'p',  :text => lorem
      end

      within '.actions' do
        page.should have_css 'span', :text => '6 acciones esta semana'
        page.should have_link 'Sigue a Virginia'
      end

      within '.questions' do
        page.should have_css 'span', :text => 'Una pregunta contestada'
        page.should have_link 'Pregunta a Virginia'
      end
    end
  end

  context 'being a signed-in user' do
    before do
      login_as_regular_user
    end

    scenario "allows to send a question to this politic" do
      visit politic_path(@politic)

      within '#politic_summary' do
        within '.make_a_question' do
          page.should have_css 'h3', :text => 'Pregunta a Virginia'
          fill_in 'Haz una pregunta a Virginia...', :with => 'Test question'
          expect{ click_button 'Preguntar'}.to change{ Question.count }.by(1)
        end
      end

      page.should have_content 'Tu pregunta se ha enviado correctamente y será publicada en cuanto nuestro equipo de moderación la haya revisado. También te avisaremos cuando recibas respuesta.'

    end
  end

  context 'not being a signed-in user' do

    scenario "doesn't allow to send a question to this politic" do
      visit politic_path(@politic)

      within '#politic_summary' do
        page.should have_no_css '.make_a_question'
      end

    end
  end


  scenario 'shows a list of last actions related to this politic' do

    visit politic_path(@politic)

    within '#last_actions' do
      page.should have_css 'h2', :text => 'Últimas acciones'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.action div.answer' do
        page.should have_css 'p.title', :text => 'Contestando a "Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'
        page.should have_css 'p.answer', :text => '"Hola María, en realidad no va a haber ayuda este año. El recorte este"'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => 'Virginia Uriarte Rodríguez contesto hace menos de 1 minuto'
        page.should have_css 'span.author a', :text => 'Virginia Uriarte Rodríguez'
        page.should have_css 'a', :text => '1 comentario'
        page.should have_css 'a', :text => 'Compartir'
      end

      within 'ul li.action div.news' do
        page.should have_css 'p.title', :text => 'Inauguración del nuevo complejo deportivo en la localidad de Getxo'
        page.should have_css 'p.news', :text => %{"#{lorem}"}

        page.should have_no_css 'img'
        page.should have_css 'span.author', :text => 'Publicado hace menos de 1 minuto'
        page.should have_css 'a', :text => '2 comentarios'
        page.should have_css 'a', :text => 'Compartir'
      end

      within '.content_type_filters' do
        page.should have_link 'Todos los tipos'
        page.should have_link 'Noticias'
        page.should have_link 'Actividad de los políticos'
        page.should have_link 'Preguntas'
        page.should have_link 'Propuestas'
        page.should have_link 'Fotos'
        page.should have_link 'Vídeos'
      end

      page.should have_css '.pagination', :text => 'Ver más acciones'
    end
  end

  scenario "shows the list of questions made to that politic" do

    visit politic_path(@politic)

    within '#questions' do
      page.should have_css 'h2', :text => 'Preguntas de los ciudadanos'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.action:first-child div.question' do
        page.should have_css 'p.title', :text => 'Pregunta para Virginia Uriarte Rodríguez...'
        page.should have_css 'p.question', :text => '"¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?"'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css 'span.author a', :text => 'María González Pérez'
        page.should have_css 'a', :text => 'Aún no contestada'
        page.should have_css 'a', :text => '1 comentario'
      end

      within '.content_type_filters' do
        page.should have_link 'Todas'
        page.should have_link 'Contestadas'
        page.should have_link 'Haz una pregunta'
      end

      page.should have_css '.pagination', :text => 'Ver más preguntas'
    end
  end

  scenario "shows the list of proposals sent to that politic" do

    visit politic_path(@politic)

    within '#proposals' do
      page.should have_css 'h2', :text => 'Propuestas'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.action div.proposal' do
        page.should have_css 'p.title', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'
        page.should have_css 'ul.arguments li', :text => '1 a favor'
        page.should have_css 'ul.arguments li', :text => '0 en contra'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css 'span.author a', :text => 'María González Pérez'
        page.should have_css 'a', :text => 'Un usuario ha participado'
      end

      within '.content_type_filters' do
        page.should have_link 'Todas'
        page.should have_link 'Propuestas del gobierno'
        page.should have_link 'Propuestas ciudadanas'
        page.should have_link 'Crea una propuesta'
      end

      page.should have_css '.pagination', :text => 'Ver más propuestas'
    end
  end

  scenario "shows this politic's agenda" do

    visit politic_path(@politic)

    within '#agenda' do
      page.should have_css 'h2', :text => 'Agenda de Virginia'

      page.should have_css 'a.view_calendar', :text => 'Ver calendario'
      page.should have_css 'a.view_map', :text => 'Ver mapa'

      within '.calendar' do
        (1..14).each do |n|
          page.should have_css '.date .day', :text => n.to_s
          page.should have_css '.date .month', :text => 'ago'
          page.should have_no_css '.detail'
        end

        page.should have_css 'li.ago_02 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 2
        page.should have_css 'li.ago_04 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
        page.should have_css 'li.ago_11 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'

      end

      page.should have_css '.pagination', :text => 'Ver calendario completo'
    end
  end

end