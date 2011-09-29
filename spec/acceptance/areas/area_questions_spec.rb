#encoding: UTF-8

require 'spec_helper'

feature "Area's questions page" do

  background do
    @area = get_area_data
  end

  scenario "shows a summary of that area's politicians, actions and generated contents" do

    visit questions_area_path(@area)

    within '.summary' do
      page.should have_css 'h1', :text => 'Educación, Universidades e Investigación'
      page.should have_css 'a.ribbon'
      page.should have_css 'h3', :text => 'Qué hacemos'
      page.should have_css 'p',  :text => String.lorem

      within 'ul.people' do
        page.should have_css 'li a',    :text => 'Virginia Uriarte Rodríguez'
        page.should have_css 'li span', :text => 'Consejera'
        page.should have_css 'li a',    :text => 'Alberto de Zárate López'
        page.should have_css 'li span', :text => 'Vice-consejero'
      end

    #  within '.status' do
    #    page.should have_css 'ul li.area span',      :text => '148 acciones esta semana'
    #    page.should have_css 'ul li.area a',         :text => 'Sigue a este área'
    #    page.should have_css 'ul li.questions span', :text => '1 pregunta contestada'
    #    page.should have_css 'ul li.questions a',    :text => 'Haz una pregunta'
    #    page.should have_css 'ul li.proposals span', :text => '1 propuesta abierta'
    #    page.should have_css 'ul li.proposals a',    :text => 'Lanza tu propuesta'
    #  end
    end
  end

  scenario 'shows a navigation menu with "questions" selected' do
    visit questions_area_path(@area)

    within '.menu' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones'
      page.should have_link 'Preguntas', :class => 'selected'
      page.should have_link 'Propuestas'
      page.should have_link 'Agenda'
      page.should have_link 'Equipo'
    end
  end

  scenario "shows the list of questions made to that area" do

    visit questions_area_path(@area)

    within 'article.questions' do
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
        page.should have_css '.footer a.comment-count', :text => '1 comentario'
      end

      within '.question:last-child' do
        page.should have_css 'p', :text => 'Pregunta para el área...'
        page.should have_css 'p.excerpt', :text => '"Hola Virginia, llevo algún tiempo queriendo saber por qué no se pueden llevar perros, gatos u otros animales domésticos a los actos públicos."'

        page.should have_css 'img'
        page.should have_css '.footer span.published_at', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css '.footer span.published_at a', :text => 'María González Pérez'
        page.should have_css '.footer .answered', :text => 'Contestada hace menos de 1 minuto'
        page.should have_css '.footer a.comment-count', :text => 'Ningún comentario'
      end

      within 'ul.selector' do
        page.should have_link 'Todas'
        page.should have_link 'Contestadas'
      end

      page.should have_link 'Haz una pregunta'

      page.should have_css 'footer .right a', :text => 'ver más preguntas'
    end
  end
end
