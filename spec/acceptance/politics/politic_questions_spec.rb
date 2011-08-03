#encoding: UTF-8

require 'spec_helper'

feature "Area's questions page" do

  background do
    @politic = init_politic_data
  end

  scenario "shows a summary with that politic's description, actions and questions answered" do

    visit questions_politic_path(@politic)

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
        page.should have_css 'span', :text => '2 acciones esta semana'
        page.should have_link 'Sigue a Virginia'
      end

      within '.questions' do
        page.should have_css 'span', :text => 'Una pregunta contestada'
        page.should have_link 'Pregunta a Virginia'
      end
    end
  end

  scenario 'shows a navigation menu with "actions" selected' do
    visit questions_politic_path(@politic)

    within '.navigation' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones'
      page.should have_link 'Preguntas', :class => 'selected'
      page.should have_link 'Propuestas'
      page.should have_link 'Agenda'
    end
  end

  scenario "shows the list of questions made to that politic" do

    visit questions_politic_path(@politic)

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

end