#encoding: UTF-8

require 'spec_helper'

feature "Area's proposals page" do

  background do
    @politic = get_politic_data
  end

  scenario "shows a summary with that politic's description, actions and questions answered" do

    visit proposals_politic_path(@politic)

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
    visit proposals_politic_path(@politic)

    within 'ul.menu' do
      page.should have_link 'Resumen'
      page.should have_link 'Acciones'
      page.should have_link 'Preguntas'
      page.should have_link 'Propuestas', :class => 'selected'
      page.should have_link 'Agenda'
    end
  end

  scenario "shows the list of proposals sent to that politic" do

    visit proposals_politic_path(@politic)

    within '#proposals' do
      page.should have_css 'h2', :text => 'Propuestas'

      page.should have_css 'a.more_recent', :text => 'Más recientes'
      page.should have_css 'a.more_polemic', :text => 'Más polémicas'

      within 'ul li.action div.proposal' do
        page.should have_css 'p.title', :text => 'Actualizar la información publicada sobre las ayudas a familias numerosas'
        page.should have_css 'ul.arguments li', :text => '66 a favor'
        page.should have_css 'ul.arguments li', :text => '57 en contra'

        page.should have_css 'img'
        page.should have_css 'span.author', :text => 'María González Pérez hace menos de 1 minuto'
        page.should have_css 'span.author a', :text => 'María González Pérez'
        page.should have_css 'a', :text => '123 usuarios han participado'
      end

      within '.content_type_filters' do
        page.should have_link 'Todas'
        page.should have_link 'Propuestas del gobierno'
        page.should have_link 'Propuestas ciudadanas'
        page.should have_link 'Crea una propuesta'
      end

      page.should have_css '.pagination', :text => 'ver más propuestas'
    end
  end

end
