#encoding: UTF-8

require 'spec_helper'

feature "Politician's home" do

  background do
    @politician = get_politician_data
  end

  scenario "shows a summary with that politician's description, actions and questions answered" do

    visit politician_path(@politician)

    within '.summary' do
      page.should have_css 'h1', :text => 'Virginia Uriarte Rodríguez'
      page.should have_css '.position', :text => 'Consejera de Educación, Universidades e Investigación'
      page.should have_link 'Educación, Universidades e Investigación'
      page.should have_css 'img.xlAvatar'

      within '.description' do
        page.should have_css 'h3', :text => 'Quién es y qué hace'
        page.should have_css 'p',  :text => String.lorem
      end

     # within '.actions' do
     #   page.should have_css 'span', :text => '7 acciones esta semana'
     #   page.should have_link /Seguir a Virginia (.*)/
     # end

     # within '.questions' do
     #   page.should have_css 'span', :text => 'Una pregunta contestada'
     #   page.should have_link 'Pregunta a Virginia'
     # end
    end
  end

  context 'being a signed-in user' do
    before do
      login_as_regular_user
    end

    scenario "allows to send a question to this politician" do
      visit politician_path(@politician)

      within '.summary' do
        page.should have_css 'h3', :text => 'Pregunta a Virginia'
        within 'form.make_question' do
          page.should have_css 'span.holder', :text => 'Haz una pregunta a Virginia...'

          fill_in 'ask-question', :with => 'Test question'
          expect{ click_button 'Preguntar'}.to change{ Question.count }.by(1)
        end
      end

      page.should have_content 'Tu pregunta se ha enviado correctamente y será publicada en cuanto nuestro equipo de moderación la haya revisado. También te avisaremos cuando recibas respuesta.'

    end
  end

  context 'not being a signed-in user' do

    scenario "doesn't allow to send a question to this politician" do
      visit politician_path(@politician)

      within '.summary' do
        page.should have_no_css 'form.make_question'
      end

    end
  end

  scenario 'shows a list of last actions related to this politician' do

    visit politician_path(@politician)

    within '.last_actions' do
      page.should have_css 'h2', :text => 'Últimas acciones'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within '.answer' do
        page.should have_css 'p', :text => 'Contestando a "Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'
        page.should have_css 'p.excerpt', :text => '"Hola María, en realidad no va a haber ayuda este año. El recorte este"'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'Virginia Uriarte Rodríguez contesto hace menos de 1 minuto'
        page.should have_css '.footer span.published_at a', :text => 'Virginia Uriarte Rodríguez'
        page.should have_css '.footer a.comment-count', :text => '1 comentario'
        page.should have_css '.footer a', :text => 'Compartir'
      end

      within '.news' do
        page.should have_css 'p', :text => 'Inauguración del nuevo complejo deportivo en la localidad de Getxo'
        page.should have_css 'p.excerpt', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed d...'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'Publicado hace menos de 1 minuto'
        page.should have_css '.footer a.comment-count', :text => '2 comentarios'
        page.should have_css '.footer a', :text => 'Compartir'
      end

      within 'ul.selector' do
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
  end

  scenario "shows the list of questions made to that politician" do

    visit politician_path(@politician)

    within '.questions' do
      page.should have_css 'h2', :text => 'Preguntas de los ciudadanos'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within '.question:first-child' do
        #page.should have_css 'p', :text => 'Pregunta para Virginia Uriarte Rodríguez...'
        page.should have_css 'p.excerpt', :text => '"¿Cuándo va a ser efectiva la ayuda para estudiantes universitarios en 2011?"'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css '.footer span.published_at a', :text => 'María González Pérez'
        page.should have_css '.footer .not_answered', :text => 'Aún no contestada'
        page.should have_css '.footer a.comment-count', :text => '1 comentario'
      end

      within 'ul.selector' do
        page.should have_link 'Todas'
        page.should have_link 'Contestadas'
      end
      page.should have_link 'Haz una pregunta'

      page.should have_css 'footer .right a', :text => 'ver más preguntas'
    end
  end

  scenario "shows the list of proposals sent to that politician" do

    visit politician_path(@politician)

    within '.proposals' do
      page.should have_css 'h2', :text => 'Propuestas'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.proposal' do
        page.should have_css 'p', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'

        within '.graphs' do
          page.should have_css '.sparkline.positive .legend' #, :text => '66 a favor'
          page.should have_css '.sparkline.negative .legend' #, :text => '57 en contra'
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

  scenario "shows this politician's agenda" do

    visit politician_path(@politician)

    within '.agenda' do
      page.should have_css 'h2', :text => 'Agenda de Virginia'

      page.should have_css 'a.view_calendar', :text => 'Ver calendario'
      page.should have_css 'a.view_map', :text => 'Ver mapa'

      within '.content' do
        (1..14).each do |n|
          page.should have_css '.day h3', :text => n.to_s
          page.should have_css '.month', :text => 'ago'
          page.should have_no_css '.detail'
        end

       # page.should have_css 'li.ago_02 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit', :count => 2
       # page.should have_css 'li.ago_04 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
       # page.should have_css 'li.ago_11 div.title', :text => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'

      end

      page.should have_css 'footer .right a', :text => 'Ver calendario completo'
    end
  end

end
