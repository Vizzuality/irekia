#encoding: UTF-8

require 'spec_helper'

feature "Politic's actions page" do

  background do
    @politic = get_politic_data
  end

  scenario "shows a summary with that politic's description, actions and questions answered" do

    visit actions_politic_path(@politic)

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
     #   page.should have_link 'Sigue a Virginia'
     # end

     # within '.questions' do
     #   page.should have_css 'span', :text => 'Una pregunta contestada'
     #   page.should have_link 'Pregunta a Virginia'
     # end
    end
  end

  scenario 'shows a navigation menu with "actions" selected' do
    visit actions_politic_path(@politic)

    within 'ul.menu' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones', :class => 'selected'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas'
      page.should have_link 'Agenda'
    end
  end

  scenario 'shows a list of last actions related to this politic' do

    visit actions_politic_path(@politic)

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


end
