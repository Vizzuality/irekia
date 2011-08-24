#encoding: UTF-8

require 'spec_helper'

feature "Politic's actions page" do

  background do
    @politic = get_politic_data
  end

  scenario "shows a summary with that politic's description, actions and questions answered" do

    visit actions_politic_path(@politic)

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

  scenario 'shows a navigation menu with "actions" selected' do
    visit actions_politic_path(@politic)

    within '.navigation' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones', :class => 'selected'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas'
      page.should have_link 'Agenda'
    end
  end

  scenario 'shows a list of last actions related to this politic' do

    visit actions_politic_path(@politic)

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


end